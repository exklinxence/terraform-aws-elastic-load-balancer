locals {
  aws_region       = "eu-west-1"
  environment_name = "staging"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "aws networking deep dive",
    ops_source_repo_path = "exklinxence/aws-networking-deep-dive",
    ops_owners           = "collins"
  }
}