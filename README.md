# AWS VPC com Terraform

Projeto de estudo que cria uma VPC, sub-rede pública, Internet Gateway, tabela de rotas, Security Group e uma instância EC2 com Amazon Linux 2 na região `us-east-1`. O acesso SSH é permitido somente para o IP configurado.

## Requisitos

- Terraform, AWS CLI e cliente SSH instalados.
- Conta AWS com permissão para criar os recursos.
- Par de chaves SSH no computador. Caso ainda não tenha um, execute `ssh-keygen -t ed25519` e siga as instruções.

## Configuração

Configure suas próprias credenciais AWS:

```powershell
aws configure
```

Informe `us-east-1` como região. Não coloque credenciais no código ou no repositório.

Consulte seu IP público:

```powershell
curl.exe -4 https://checkip.amazonaws.com
```

Crie ou ajuste o arquivo `terraform.tfvars` na pasta do projeto, usando seu IP com `/32` e o caminho da sua chave **pública**:

```hcl
ssh_cidr        = "SEU_IP_PUBLICO/32"
public_key_path = "C:/Users/SEU_USUARIO/.ssh/id_ed25519.pub"
```

Esse arquivo é ignorado pelo Git. Se seu IP mudar, atualize-o antes de executar o Terraform novamente.

## Execução

No terminal, dentro da pasta do projeto:

```powershell
terraform init
terraform validate
terraform plan
terraform apply
```

Confirme o `apply` com `yes`. Consulte o IP criado:

```powershell
terraform output -raw public_ip
```

Conecte usando sua chave **privada** e o IP retornado:

```powershell
ssh -i "C:/Users/SEU_USUARIO/.ssh/id_ed25519" ec2-user@IP_DA_INSTANCIA
```

O output `ssh_command` contém o caminho local do autor; ajuste esse caminho em `outputs.tf` se quiser utilizá-lo no seu computador.

Dentro da sessão SSH, verifique o sistema e saia:

```bash
cat /etc/os-release
exit
```

## Limpeza

Após os testes, execute no terminal local e confirme com `yes`:

```powershell
terraform destroy
```

Aguarde `Destroy complete!`. Os recursos podem gerar custos conforme os benefícios e créditos disponíveis na sua conta; usar `t3.micro` não garante gratuidade.

As evidências de execução estão em `terraform-cli-screenshots/` e o enunciado está em `projeto.pdf`.
