output "master_ip" {
  value = aws_eip.eip_master.public_ip
}

output "workers_ip" {
  value = aws_eip.eip_workers[*].public_ip
}

output "workers_id" {
  value = aws_instance.instance_workers[*].id
}

output "key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "path_key_file" {
  value = local_file.local_key_pair.filename
}

output "user_from_ami" {
  value = data.aws_ami.ami_latest.name
}

output "sg_id" {
  value = aws_security_group.sg.id
}