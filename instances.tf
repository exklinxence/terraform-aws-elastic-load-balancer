# resource "tls_private_key" "dev_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "generated_key" {
#   key_name   = var.generated_key_name
#   public_key = tls_private_key.dev_key.public_key_openssh

#   provisioner "local-exec" { # Generate "terraform-key-pair.pem" in current directory
#     command = <<-EOT
#       echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
#       chmod 400 ./'${var.generated_key_name}'.pem
#     EOT
#   }

# }

# creating key
resource "tls_private_key" "task1-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#generating key-value pair
resource "aws_key_pair" "task1-key" {
  key_name   = "task1key"
  public_key = tls_private_key.task1-key.public_key_openssh
}
# saving key to pem file
resource "local_file" "task1-key" {
  content  = tls_private_key.task1-key.private_key_pem
  filename = "~/terraform/task1key.pem"
  depends_on = [
    tls_private_key.task1-key
  ]
}

resource "aws_instance" "web1" {
  ami = var.instance-ami

  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  instance_type               = var.instance-type
  private_ip                  = "170.31.1.21"
  subnet_id                   = aws_subnet.web-1a.id
  key_name                    = aws_key_pair.task1-key.key_name
  associate_public_ip_address = true

  tags = local.tags
}

resource "aws_instance" "web2" {
  ami                    = var.instance-ami
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  instance_type          = var.instance-type
  private_ip             = "170.31.2.22"
  subnet_id              = aws_subnet.web-1b.id
  key_name               = aws_key_pair.task1-key.key_name

  tags = local.tags
}


resource "aws_instance" "web3" {
  ami                    = var.instance-ami
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  instance_type          = var.instance-type
  private_ip             = "170.31.2.23"
  subnet_id              = aws_subnet.web-1b.id
  key_name               = aws_key_pair.task1-key.key_name

  tags = local.tags
}

resource "aws_instance" "app1" {
  ami                    = var.instance-ami
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  instance_type          = var.instance-type
  private_ip             = "170.31.101.21"
  subnet_id              = aws_subnet.app-1a.id
  key_name               = aws_key_pair.task1-key.key_name

  tags = local.tags
}

resource "aws_instance" "app2" {
  ami                    = var.instance-ami
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  instance_type          = var.instance-type
  private_ip             = "170.31.102.22"
  subnet_id              = aws_subnet.app-1b.id
  key_name               = aws_key_pair.task1-key.key_name

  tags = local.tags
}

resource "aws_instance" "app3" {
  ami                    = var.instance-ami
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  instance_type          = var.instance-type
  private_ip             = "170.31.102.23"
  subnet_id              = aws_subnet.app-1b.id
  key_name               = aws_key_pair.task1-key.key_name

  tags = local.tags
}

resource "aws_instance" "db" {
  ami                    = var.instance-ami
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  instance_type          = var.instance-type
  private_ip             = "170.31.101.99"
  subnet_id              = aws_subnet.app-1a.id
  key_name               = aws_key_pair.task1-key.key_name

  tags = local.tags
}