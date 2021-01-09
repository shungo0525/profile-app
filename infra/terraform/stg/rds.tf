resource "aws_db_instance" "main" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0.11"
  instance_class         = "db.t3.small"
  name                   = "mydb"
  username               = "user"
  password               = "password"
  parameter_group_name   = "default.mysql8.0"
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [module.for_rds.security_group_id]
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.app_name}-db-subnet-group-${var.environment}"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = "${var.app_name}-db-subnet-${var.environment}"
  }
}

module "for_rds" {
  source      = "../modules/security_group"
  name        = "for_rds"
  vpc_id      = aws_vpc.main.id
  port        = 3306
  cidr_blocks = [aws_vpc.main.cidr_block]
}
