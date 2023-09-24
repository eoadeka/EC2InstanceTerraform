provider "aws" {
    region = "eu-west-2"
    access_key = var.access_key
    secret_key = var.secret_key
}

# Create vpc
resource "aws_vpc" "terraform-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "terraform-vpc"
    }
}

# 4. Create a Subnet
resource "aws_subnet" "terraform-subnet" {
    vpc_id = aws_vpc.terraform-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-2a"
    tags = {
      Name = "terraform-subnet"
    }
}

# Create securiy group to allow traffic on ports 22, 80, 443
resource "aws_security_group" "terraform_sg" {
    name = "allow_web_traffic_terraform2"
    description = "allow web traffic for terraform"
    vpc_id = aws_vpc.terraform-vpc.id

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "allow_web_terraform"
    }
}



# Create EC2 Instance
resource "aws_instance" "terraform-instance" {
    ami = var.ami
    instance_type = "t2.micro"
    availability_zone = "eu-west-2a"
    subnet_id = aws_subnet.terraform-subnet.id
    vpc_security_group_ids = [ aws_security_group.terraform_sg.id ]
    key_name = "terraform-masterkey"
     

    tags = {
      Name = "terraformy"
    }
}
