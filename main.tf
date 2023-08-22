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

module "deploy_instances" {
  source = "./modules/deploy_instances"
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
  name_group_master = var.name_group_master 
  name_group_workers = var.name_group_workers
  master_ip = module.deploy_instances.master_ip
  workers_ip = module.deploy_instances.workers_ip.*
  key_name = module.deploy_instances.key_name
  user = var.user
}

resource "null_resource" "instance_deploy" {
    triggers = {
    timestamp = timestamp() //for ansible-playbook to to run always
  }

  provisioner "remote-exec" {
    inline = ["hostname"]
    connection {
      host = "${module.deploy_instances.master_ip}"
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(module.deploy_instances.path_key_file)}"
    }
  }
  
  provisioner "local-exec" {
    command = "cd ansible/k8s_deploy_with_crio/ && ansible-playbook-e name_group_master=${var.name_group_master} -e name_group_workers=${var.name_group_workers} main.yml"
  }
}