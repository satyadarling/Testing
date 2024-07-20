output "instance_ips" {
  value = aws_instance.example.*.public_ip
}
