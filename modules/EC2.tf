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

output "instance_public_ip" {
	description = "IP pública de la instancia EC2"
	value       = module.ec2_ssm.instance_public_ip
}

output "instance_id" {
	description = "ID de la instancia EC2"
	value       = module.ec2_ssm.instance_id
}

output "instance_profile_name" {
	description = "Nombre del Instance Profile usado por SSM"
	value       = module.ec2_ssm.instance_profile_name
}

