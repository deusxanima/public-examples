output "ec2_instance_ids" {
  value = module.ec2.instance_ids
}

output "user_data_values" {
  value = module.ec2.user_data_values
}

output "role_mappings" {
  value = module.ec2.role_mappings
}