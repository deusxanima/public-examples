module "ec2" {
  source                = "../../modules/ec2"
  instance_type         = var.instance_type
  instance_names        = local.instance_names
  subnet_id             = var.subnet_id
  ami_id                = var.ami_id
  vpc_id                = var.vpc_id
  ssh_key               = var.ssh_key

  security_group_ids    = var.security_group_ids
  tags                  = var.tags

  user_data = {
    "db_discovery"    = file("${path.module}/db-discovery-user-data.sh")
    "ec2_discoverable" = file("${path.module}/discoverable-user-data.sh")
  }

  role                  = var.role
  nodes                 = var.nodes
  instance_profiles     = var.instance_profiles
}


