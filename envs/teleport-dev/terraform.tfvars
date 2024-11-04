# Infra vars

ami_id                = "ami-047d7c33f6e7b4bc4"
vpc_id                = "vpc-087eaa541fd247c21"
subnet_id             = "subnet-01d65da5572f7842dc"
security_group_ids    = ["sg-0eeb02av4a3fd844e"]
ssh_key               = "west1-key"

tags = {
  Name = "placeholder"
  "instance_metadata_tagging_req" = "name@some.domain"
  "teleport.dev/creator"          = "name@some.domain"
}

nodes = {
  "db-discovery-svc"      = "db_discovery"
  "ssh-node"              = "ec2_discoverable"
  "ssh-node-2"            = "ec2_discoverable"
}


instance_profiles = {
  "db-discovery-svc"      = "db_discovery_profile"
  "ssh-node"              = "ec2_discoverable_profile"
  "ssh-node-2"            = "ec2_discoverable_profile"
}


# Teleport vars

teleport_version          = "16.4.3"
teleport_edition          = "enterprise"
ssm_token_path            = "/path/to/teleport/auth/token"
proxy_service_address     = "proxy.example.com:443"
role                      = "db_disovery"