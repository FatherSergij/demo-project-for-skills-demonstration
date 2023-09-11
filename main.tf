provider "aws" {
  region = var.region
  default_tags {
    tags = var.tag
  }
}

provider "aws" {
  region = var.region_s3
  alias = "s3"
  default_tags {
    tags = var.tag
  }
}

resource "aws_s3_bucket" "tfstate" {
  provider = aws.s3
  bucket_prefix = "terraform-tfstate"
}

resource "aws_s3_bucket_versioning" "versioning_enabled" {
  provider = aws.s3
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_enabled" {
  provider = aws.s3
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "tfstate" {
  provider = aws.s3
  bucket = aws_s3_bucket.tfstate.id
  key = "terraform.tfstate"
  source = "terraform.tfstate"
  depends_on = [
    aws_s3_bucket.tfstate,
    aws_s3_bucket_versioning.versioning_enabled,
    aws_s3_bucket_server_side_encryption_configuration.encrypt_enabled
  ]
}

data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    region = var.region_s3
    bucket = aws_s3_object.tfstate.id
    key    = "terraform.tfstate"           
  }
}

output name {
  //value = data.terraform_remote_state.s3.outputs.workers_ip
  value = data.terraform_remote_state.s3.outputs.aws_s3_bucket.tfstate.tags
}

/*terraform {
  backend "s3" {
    region = "eu-north-1"
    bucket = "12345-terraform-tfstate"
    key = "terraform.tfstate"
  }
}*/

/*module "vpc_create" {
  source      = "./modules/aws_vpc_create"
  my_name     = var.my_name
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

module "deploy_instances" {
  source               = "./modules/deploy_instances"
  vpc_id               = module.vpc_create.vpc_id
  subnet_id            = module.vpc_create.subnet_id
  nm_worker            = var.numbers_instans_workers_deploy
  my_name              = var.my_name
  port                 = var.port
  instance_type_master = var.instance_type_master_deploy
  instance_type_worker = var.instance_type_worker_deploy
  path_for_ansible     = var.path_for_ansible
}

locals {
  user_name = var.user[substr(module.deploy_instances.user_from_ami, 0, 4)] //Can do it as below
  //user_name = lookup(var.user, substr(module.deploy_instances.user_from_ami, 0, 4))  
}

module "create_files" {
  source           = "./modules/create_files"
  path_for_ansible = var.path_for_ansible
  master_ip        = module.deploy_instances.master_ip
  workers_ip       = module.deploy_instances.workers_ip.*
  key_name         = module.deploy_instances.key_name
  user             = local.user_name
}*/

/*resource "null_resource" "instance_deploy" {
  triggers = {
    timestamp = timestamp() //for ansible-playbook to to run always
  }

  provisioner "remote-exec" {
    inline = ["hostname"]
    connection {
      host        = module.deploy_instances.master_ip
      type        = "ssh"
      user        = local.user_name
      private_key = file(module.deploy_instances.path_key_file)
    }
  }

  provisioner "local-exec" {
    command = "cd ansible/ && ansible-playbook main.yml"
  }
}*/