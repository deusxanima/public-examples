#!/bin/bash

# Install Teleport
curl https://cdn.teleport.dev/install-v${teleport_version}.sh | bash -s ${teleport_version} ${teleport_edition}

# Retrieve token from AWS SSM Parameter Store
auth_token=$(aws ssm get-parameter --name "${ssm_token_path}" --with-decryption --query "Parameter.Value" --output text)

# Store the auth token in a file for Teleport to access
echo $auth_token > /var/lib/teleport/join_token

# Create the Teleport configuration for RDS Discovery
cat <<EOF >/etc/teleport.yaml
version: v3
teleport:
  auth_token: /var/lib/teleport/token
  proxy_server: ${proxy_service_address}
auth_service:
  enabled: false
proxy_service:
  enabled: false
ssh_service:
  enabled: false
discovery_service:
  enabled: true
  aws:
    - types: ["rds"]
      regions: ["us-east-1","us-west-1"]
      tags:
        "env": "prod"
EOF

# Start Teleport using the discovery configuration
systemctl restart teleport
