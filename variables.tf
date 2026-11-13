variable "ssh_cidr" {
  type = string

  validation {
    condition     = can(cidrnetmask(var.ssh_cidr)) && can(regex("/32$", var.ssh_cidr))
    error_message = "Informe um unico IP publico IPv4 com /32."
  }
}

variable "public_key_path" {
  type = string

  validation {
    condition     = var.public_key_path != ""
    error_message = "Informe o caminho da sua chave publica SSH."
  }
}
