resource "aws_instance" "web-server" {
  ami = "ami-0f924dc71d44d23e2"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet_a.id
}