resource "aws_db_instance" "banco" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  db_name = var.database-name
  username = var.database-username
  password = var.database-password
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
}
resource "aws_db_subnet_group" "db_subnet" {
  name = "db-subnet"
  subnet_ids = [aws_subnet.private_subnet_c.id,aws_subnet.private_subnet_d.id]
}