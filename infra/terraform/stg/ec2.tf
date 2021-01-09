// 最新のAmazonLinux2のAMI IDを取得
data aws_ssm_parameter "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "a" {
  ami = data.aws_ssm_parameter.amzn2_ami.value
  vpc_security_group_ids = [aws_security_group.for_api_server_ec2.id, module.for_ssh.security_group_id]
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_a_api_server.id
  key_name = aws_key_pair.deploy_key_pair.id

  tags = {
    Name = "${var.app_name}-ec2-a-${var.environment}"
  }
}

resource "aws_instance" "c" {
  ami = data.aws_ssm_parameter.amzn2_ami.value
  vpc_security_group_ids = [aws_security_group.for_api_server_ec2.id, module.for_ssh.security_group_id]
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public_c_api_server.id
  key_name = aws_key_pair.deploy_key_pair.id

  tags = {
    Name = "${var.app_name}-ec2-c-${var.environment}"
  }
}

resource "aws_security_group" "for_api_server_ec2" {
  name   = "for-ec2"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.for_alb.security_group_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "for_ssh" {
  source = "../modules/security_group"
  name = "for_ssh"
  vpc_id      = aws_vpc.main.id
  port        = 22
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_key_pair" "deploy_key_pair" {
  key_name = "${var.app_name}-key-pair-${var.environment}"
  public_key = var.public_key_stg
}

resource "aws_eip" "a" {
  instance = aws_instance.a.id
  vpc = true

  tags = {
    Name = "${var.app_name}-eip-a-${var.environment}"
  }
}

resource "aws_eip" "c" {
  instance = aws_instance.c.id
  vpc = true

  tags = {
    Name = "${var.app_name}-eip-c-${var.environment}"
  }
}
