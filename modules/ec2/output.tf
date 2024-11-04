output "instance_ids" {
  value = {
    for name, instance in aws_instance.ec2_node :
    name => instance.id
  }
}

output "user_data_values" {
  value = { for instance_name, role in var.nodes : instance_name => lookup(var.user_data, role, "not found") }
}

output "debug_user_data" {
  value = { for instance_name, role in var.nodes : instance_name => role }
}

output "role_mappings" {
  value = var.nodes
}

