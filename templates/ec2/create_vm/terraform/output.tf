output "instance_id" {
  description = "ID of the EC2 instance."
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Public IP of the EC2 instance."
  value       = module.ec2.public_ip
}

output "private_ip" {
  description = "Private IP of the EC2 instance."
  value       = module.ec2.private_ip
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the instance."
  value       = module.ec2.iam_role_arn
}
