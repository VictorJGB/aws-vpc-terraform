output "public_ip" {
  value = aws_instance.main.public_ip
}

output "ssh_command" {
  value = "ssh -i \"C:/Users/victor-suporte/.ssh/id_ed25519\" ec2-user@${aws_instance.main.public_ip}"
}
