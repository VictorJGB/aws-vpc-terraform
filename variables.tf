variable "ssh_cidr" {
  description = "187.19.187.45/32"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_cidr)) && can(regex("/32$", var.ssh_cidr))
    error_message = "Informe um unico IP publico IPv4 com /32."
  }
}

variable "public_key_path" {
  description = "Caminho da chave publica SSH (.pub) correspondente a sua chave privada."
  type        = string

  validation {
    condition     = var.public_key_path != ""
    error_message = "Informe o caminho da sua chave publica SSH."
  }
}
