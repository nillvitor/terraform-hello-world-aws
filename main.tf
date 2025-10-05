terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.12-x86_64"]
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "${var.tag_name}-sg"
  description = "Permite trafego HTTP de qualquer origem"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tag_name}-sg"
  }
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux.id

  key_name = var.ec2_key_name

  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Atualiza os pacotes usando dnf
              dnf update -y
              # Instala o NGINX diretamente com dnf
              dnf install -y nginx
              # Inicia e habilita o serviço do NGINX
              systemctl start nginx
              systemctl enable nginx
              # Cria o arquivo index.html
              echo '<!DOCTYPE html>
              <html>
              <head>
                  <style>
                      body {
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          font-family: sans-serif;
                          font-size: 2em;
                          color: white;
                          transition: background-color 0.5s;
                          background-color: #34495e;
                      }
                      div {
                          cursor: pointer;
                          padding: 20px;
                          border-radius: 10px;
                          box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);  
                      }
                  </style>
              </head>
              <body>
                  <div onclick="changeColor()">
                      Hello World
                  </div>
                  <script>
                      function changeColor() {
                          const colors = ["#3498db", "#2ecc71", "#e74c3c", "#f39c12", "#9b59b6"];
                          const randomColor = colors[Math.floor(Math.random() * colors.length)];
                          document.body.style.backgroundColor = randomColor;
                      }
                  </script>
              </body>
              </html>' > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = var.tag_name
  }
}

output "instance_public_ip" {
  description = "IP publico da instancia EC2"
  value       = aws_instance.web_server.public_ip
}
