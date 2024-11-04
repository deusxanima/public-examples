resource "aws_instance" "ec2_node" {
  for_each                = var.nodes

  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.security_group_ids
  key_name                = var.ssh_key

  iam_instance_profile = lookup(var.instance_profiles, each.key, "ec2_discoverable_instance_profile")

  user_data               = lookup(var.user_data, var.nodes[each.key], "")
  
  tags = merge(var.tags, {
    Name = each.key
  })

  volume_tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_iam_policy" "ec2_discovery_policy" {
  name        = "ec2_discovery_policy"
  description = "Policy for EC2 discovery node"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "iam:GetPolicy",
          "iam:TagPolicy",
          "iam:ListPolicyVersions",
          "iam:CreatePolicyVersion",
          "iam:CreatePolicy",
          "ssm:CreateDocument",
          "iam:DeletePolicyVersion",
          "iam:AttachRolePolicy",
          "iam:PutRolePermissionsBoundary"
        ],
        "Resource": "*"
      }
    ]
  })
}


resource "aws_iam_policy" "db_discovery_policy" {
  name        = "ec2_discovery_policy"
  description = "Policy for EC2 discovery node"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RDSDiscovery",
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances"
            ],
            "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_discoverable_policy" {
  name        = "ec2_discoverable_policy"
  description = "Policy for Teleport discoverable node"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssm:DescribeAssociation",
          "ssm:GetDeployablePatchSnapshotForInstance",
          "ssm:GetDocument",
          "ssm:DescribeDocument",
          "ssm:GetManifest",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:PutInventory",
          "ssm:PutComplianceItems",
          "ssm:PutConfigurePackageResult",
          "ssm:UpdateAssociationStatus",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:UpdateInstanceInformation"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  for_each = var.nodes
  
  name = "${var.nodes[each.key]}_role" 
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  for_each = var.nodes

  role = aws_iam_role.ec2_role[each.key].name

  policy_arn = lookup(
    {
      "ec2_discoverable" = aws_iam_policy.ec2_discoverable_policy.arn,
      "ec2_discovery"    = aws_iam_policy.ec2_discovery_policy.arn,
      "db_discovery"     = aws_iam_policy.db_discovery_policy.arn
    },
    var.nodes[each.key],
    null
  )
}

resource "aws_iam_instance_profile" "ec2_instance_profile" { 
  for_each = var.nodes
  
  name = "${var.nodes[each.key]}_instance_profile" 
  role = aws_iam_role.ec2_role[each.key].name 
}
