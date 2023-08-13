provider "aws" {
  region = var.region
  default_tags {
    tags = var.tag  
  }
}

module "vpc_create" {
  source = "./modules/aws_vpc_create"
  my_name = var.my_name
}

module "deploy" {
  source = "./modules/aws_deploy"
  vpc_id = module.vpc_create.vpc_id
  subnet_id = module.vpc_create.subnet_id  
  nm_worker = var.numbers_instans_workers_deploy  
  my_name = var.my_name  
  instance_type_master = var.instance_type_master_deploy
  instance_type_worker = var.instance_type_worker_deploy
  path_for_ansible = var.path_for_ansible
}

module "create_files" {
  source = "./modules/create_files"
  path_for_ansible = var.path_for_ansible
  master_ip = module.deploy.master_ip
  workers_ip = module.deploy.workers_ip.*
  key_name = module.deploy.key_name
  user = var.user
}

resource "terraform_data" "instance_deploy" {
  provisioner "remote-exec" {
    inline = ["hostname"]
    connection {
      host = "${module.deploy.master_ip}"
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(module.deploy.path_key_file)}"
    }
  }
  
  provisioner "local-exec" {
    command = "cd ansible/k8s_deploy_with_crio/ && ansible-playbook main.yml"
  }
}