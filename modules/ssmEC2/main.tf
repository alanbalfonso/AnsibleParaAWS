data "aws_vpc" "default" {
	default = true
}

data "aws_subnets" "default_vpc" {
	filter {
		name   = "vpc-id"
		values = [data.aws_vpc.default.id]
	}
}

resource "aws_security_group" "this" {
	name_prefix = "${var.instance_name}-ssm-"
	description = "Security group for SSM managed instance"
	vpc_id      = data.aws_vpc.default.id

	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_iam_role" "this" {
	name = "${var.instance_name}-ssm-role"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect = "Allow"
				Action = "sts:AssumeRole"
				Principal = {
					Service = "ec2.amazonaws.com"
				}
			}
		]
	})
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
	role       = aws_iam_role.this.name
	policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
	name = "${var.instance_name}-instance-profile"
	role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
	ami                    = var.ami_id
	instance_type          = var.instance_type
	subnet_id              = data.aws_subnets.default_vpc.ids[0]
	vpc_security_group_ids = [aws_security_group.this.id]
	iam_instance_profile   = aws_iam_instance_profile.this.name
	associate_public_ip_address = true
	user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    export DEBIAN_FRONTEND=noninteractive

    apt-get update -qq
    apt-get install -y software-properties-common
    add-apt-repository --yes --update ppa:ansible/ansible
    apt-get install -y ansible
  EOF

	tags = {
		Name = var.instance_name
	}
}