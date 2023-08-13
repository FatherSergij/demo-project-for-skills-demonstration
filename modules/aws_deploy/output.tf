output "master_ip" {
  value = aws_eip.eip_master.public_ip
}

output "workers_ip" {
  value = aws_eip.eip_workers[*].public_ip
}

output "key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "master" {
  value = aws_instance.instance_master.id
}

output "workers" {
  value = aws_instance.instance_workers[*].id
}

output "path_key_file" {
  value = local_file.local_key_pair.filename
}