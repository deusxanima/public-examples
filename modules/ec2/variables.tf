variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
}

variable "instance_names" {
  description = "List of instance names to create"
  type        = list(string)
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EC2 instance will be created"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be created"
  type        = string
}

variable "security_group_ids" {
  description = "The security group IDs to associate with the EC2 instance"
  type        = list(string)
}

variable "ssh_key" {
  description = "The ssh key for accessing the EC2 instance"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "User data to pass to the instance"
  type        = map(string)
  default     = {}
}

variable "role" {
  description = "Role type for the EC2 instance (e.g., ec2_discoverable or db_discovery)"
  type        = string
}

variable "nodes" {
  type        = map(string)
  description = "Mapping of node names to their types (e.g., ssh, ec2_discovery)"
}

variable "instance_profiles" {
  type        = map(string)
  description = "Mapping of node names to IAM instance profiles"
}

# Teleport vars

variable "teleport_version" {
  default = "16.4.3"
}

variable "teleport_edition" {
  default = "enterprise"
}

variable "ssm_token_path" {
  default = "/path/to/teleport/auth/token"
}

variable "proxy_service_address" {
  default = "proxy.example.com:443"
}

variable "aws_assume_role_arn" {
  default = "arn:aws:iam::123456789012:role/rds-discovery"
}
