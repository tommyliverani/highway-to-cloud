output "instance_id" {
  description = "ID of the EC2 instance."
  value       = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "Public IP of the EC2 instance."
  value       = module.ec2_instance.public_ip
}

output "private_ip" {
  description = "Private IP of the EC2 instance."
  value       = module.ec2_instance.private_ip
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the instance."
  value       = module.ec2_instance.iam_role_arn
}
