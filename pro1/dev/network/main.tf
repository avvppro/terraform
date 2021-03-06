provider "aws" {
  region = data.terraform_remote_state.global_vars.outputs.region
}

data "terraform_remote_state" "global_vars" { // data from pro1/dev/global_vars for sg creation
  backend = "s3"
  config = {
    bucket = "avvppro-terraform.tfstate-bucket"
    key    = "pro1/dev/global_vars/terraform.tfstate"
    region = "eu-central-1"
  }
}

terraform { // terraform_remote_state  bucket
  backend "s3" {
    bucket = "avvppro-terraform.tfstate-bucket"
    key    = "pro1/dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}
module "vpc" { // overrides variables set in /modules/aws_network/variables.tf directory
  source               = "git@github.com:avvppro/terraform.git//modules/aws_network"
  env                  = "dev"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = []
}
