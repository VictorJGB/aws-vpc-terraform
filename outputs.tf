output "public_ip" {
  description = "IP publico da instancia."
  value       = aws_instance.main.public_ip
}

output "ssh_command" {
  description = "Substitua CAMINHO_DA_CHAVE_PRIVADA pelo caminho da sua chave privada."
  value       = "ssh -i CAMINHO_DA_CHAVE_PRIVADA ec2-user@${aws_instance.main.public_ip}"
}
