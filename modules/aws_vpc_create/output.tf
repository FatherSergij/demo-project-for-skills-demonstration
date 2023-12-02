output "vpc_id" {
  value = aws_vpc.aws_vpc_my.id
}

output "subnet_id" {
  value = aws_subnet.aws_subnet_my[*].id
}

output "volume_id" {
  value = aws_ebs_volume.volume_for_prometheus.id
}