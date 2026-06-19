variable "name" {
  description = "Name tag for the EC2 instance."
  type        = string
}

variable "ami" {
  description = "AMI ID to use for the instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "inline_policy_statements" {
  description = "Lista di statement IAM da includere nella policy inline del ruolo EC2."
  type = list(object({
    Effect    = string
    Action    = list(string)
    Resource  = list(string)
  }))
  default = []
}