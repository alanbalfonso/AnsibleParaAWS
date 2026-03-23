module "ec2_ssm" {
	source = "./ssmEC2"

	instance_name = var.instance_name
	ami_id        = var.ami_id
	instance_type = var.instance_type
}

variable "instance_name" {
	type = string
}

variable "ami_id" {
	type = string
}

variable "instance_type" {
	type = string
}