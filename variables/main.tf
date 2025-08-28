provider "aws" {
  region = "ap-south-1"
}

variable "vpcname" {
  type = string
  default = "myvpc"
}

variable "sshport" {
  type = number
  default = 22
}

# Boolean Variable
variable "enabled" { 
  default = true
}

variable "mylist" {
  type = list(string)
  default = [ "Value1", "Value2" ]
}

# map variable
variable "mymap" {
  type = map(number)
  default = {
    "Key1" = 0
    "Key2" = 1
  }
}

variable "inputname" {
  type = string
  description = "Enter your VPC name"
}

resource "aws_vpc" "myvpc" {
   cidr_block = "10.0.0.0/16"

   tags = {
     Name = var.inputname
   }
}


# Check attributes doc on google for more info on outputs
output "vpcid" {
    value = aws_vpc.myvpc.id
}