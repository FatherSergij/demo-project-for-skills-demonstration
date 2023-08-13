locals {
  postfix_config_hosts = <<-EOT
[k8s_master]
master ansible_host=${var.master_ip}

[k8s_workers]
%{ for ip_addr in var.workers_ip.* ~} 
worker0${index(var.workers_ip.*, ip_addr) + 1} ansible_host=${ip_addr}
%{ endfor ~}
  EOT
}

locals {
  postfix_config_vars = <<-EOT
ansible_user : "${var.user}"
ansible_ssh_private_key_file : ${var.key_name}
  EOT
}

resource "local_file" "postfix_config_hosts" {
  filename = "${var.path_for_ansible}hosts"
  file_permission = "0660"
  content  = local.postfix_config_hosts
}

resource "local_file" "postfix_config_vars_srv" {
  filename = "${var.path_for_ansible}group_vars/k8s_master"
  file_permission = "0660"
  content  = local.postfix_config_vars
}

resource "local_file" "postfix_config_vars_wrk" {
  filename = "${var.path_for_ansible}group_vars/k8s_workers"
  content  = local.postfix_config_vars
}