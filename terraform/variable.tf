variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t2.micro"
}
variable "subnet_id" {
  description = "The type of subnet to create"
  type        = string
  default     = "subnet-0d49df036877a4822"
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to assign to the instance"
  type        = list(string)
}

variable "tags" {
  description = "Tags to assign to the instance"
  type        = map(string)
}
