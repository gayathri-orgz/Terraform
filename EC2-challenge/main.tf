provider "aws" {
  region = "ap-south-1"
}

variable "allowed_ports" {
  type = list(string)
  default = [ "80", "443" ]
}

resource "aws_instance" "dbserver" {
  ami = "ami-0861f4e788f5069dd"
  instance_type = "t3.micro"
  
  tags = {
    Name = "DB_server"
  }
}

resource "aws_instance" "webserver" {
  ami = "ami-0861f4e788f5069dd"
  instance_type = "t3.micro"
  security_groups = [ aws_security_group.websvr_sg.name ]

  tags = {
    Name = "web_server"
  }
}

resource "aws_eip" "websvr_ip" {
  instance = aws_instance.webserver.id
}

resource "aws_security_group" "websvr_sg" {
  name = "sg_for_webserver"

  tags = {
    Name = "allow_ssh_https"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.websvr_sg.id
  for_each          = toset(var.allowed_ports)
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
  cidr_ipv4         = "0.0.0.0/0"

}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.websvr_sg.id
  for_each          = toset(var.allowed_ports)
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
  cidr_ipv4         = "0.0.0.0/0"
}


# Retrieving elastic IP of the web server
output "publicip" {
  value = aws_eip.websvr_ip.public_ip
}


# Retrieving private IP of the DB server
output "privateip" {
  value = aws_instance.dbserver.private_ip
}