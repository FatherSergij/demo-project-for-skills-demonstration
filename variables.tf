variable "region" {
  default = "eu-north-1"
}

variable "path_for_ansible" {
  default = "ansible/k8s_deploy_with_crio/"
}

variable "name_group_master" {
  default = "ansible_master"
}

variable "name_group_workers" {
  default = "ansible_workers"
}

variable "tag" {
  type = map(string)
  default = {
      kubernetes  = "owned",
      ManagedBy   = "Terraform"
  }
}

variable "my_name" {
  default = "k8s"
}

variable "numbers_instans_workers_deploy" {
  default = 3
}

variable "instance_type_master_deploy" {
  default = "t3.small"
}

variable "instance_type_worker_deploy" {
  default = "t3.micro"
}

variable "user" {
  default = "ubuntu"
}