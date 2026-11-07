terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

# Rede do ambiente de testes.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Sub-rede publica com IP publico para a instancia.
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Gateway para acesso a internet.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Rota de saida para a internet.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# Associa a rota a sub-rede publica.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Permite SSH somente do IP informado e libera o trafego de saida.
resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Seleciona a AMI Amazon Linux 2 x86_64 da Amazon na regiao.
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Registra a chave publica; a chave privada permanece no seu computador.
resource "aws_key_pair" "ssh" {
  key_name_prefix = "capacita-"
  public_key      = file(pathexpand(var.public_key_path))
}

# Instancia de testes acessivel via SSH.
resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ssh.id]
  key_name               = aws_key_pair.ssh.key_name

  depends_on = [aws_route_table_association.public]
}
