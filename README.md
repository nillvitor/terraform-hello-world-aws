# Terraform "Hello World" na AWS

Este projeto utiliza o Terraform para provisionar um servidor web "Hello World" simples em uma instância EC2 na AWS.

## Descrição

A configuração do Terraform criará os seguintes recursos:

*   Uma **instância EC2** (`t3.micro`) usando a AMI mais recente do Amazon Linux 2023.
*   Um **Security Group** que permite tráfego HTTP na porta 80 de qualquer origem e todo o tráfego de saída.
*   A instância EC2 é inicializada com um script (`user_data`) que instala e inicia o NGINX, e cria uma página `index.html` personalizada e interativa.

## Pré-requisitos

Antes de começar, certifique-se de que você tem o seguinte instalado e configurado:

*   Terraform (versão 1.0 ou superior)
*   AWS CLI
*   Credenciais da AWS configuradas (por exemplo, via `aws configure`)
*   Um par de chaves EC2 existente na região da AWS que você irá utilizar.

## Como Usar

1.  **Clone o repositório:**
    ```sh
    git clone https://github.com/nillvitor/terraform-hello-world-aws.git
    cd terraform-hello-world-aws
    ```

2.  **Crie um arquivo de variáveis:**
    O Terraform precisa saber o nome da sua chave EC2. Crie um arquivo chamado `terraform.tfvars` e adicione o nome da sua chave:
    ```terraform
    ec2_key_name = "seu-nome-de-chave"
    ```
    Substitua `"seu-nome-de-chave"` pelo nome do seu arquivo de chave `.pem` (sem a extensão).

3.  **Inicialize o Terraform:**
    Este comando inicializa o diretório de trabalho, baixando o provedor da AWS.
    ```sh
    terraform init
    ```

4.  **Planeje a infraestrutura:**
    Revise os recursos que o Terraform criará.
    ```sh
    terraform plan
    ```

5.  **Aplique a configuração:**
    Este comando criará os recursos na sua conta da AWS.
    ```sh
    terraform apply
    ```
    Digite `yes` quando solicitado para confirmar. Ao final, o IP público da instância será exibido.

## Acessando o Servidor Web

Após a conclusão do `terraform apply`, copie o valor de `instance_public_ip` e cole-o no seu navegador. Você verá a página "Hello World".

## Limpeza

Para destruir todos os recursos criados por este projeto e evitar custos, execute:
```sh
terraform destroy
```
Digite `yes` para confirmar a destruição.