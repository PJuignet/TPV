provider "aws" {
	region = "eu-west-3"
}

resource "aws_vpc" "<##INFRA_NAME##>-vpc" {
	cidr_block = "10.0.0.0/16"

	tags = {
		Name = "<##INFRA_NAME##>-vpc"
	}
}

resource "aws_subnet" "<##INFRA_NAME##>-pub" {
	vpc_id = "${aws_vpc.<##INFRA_NAME##>-vpc.id}"
	cidr_block = "10.0.1.0/24"

	tags = {
		Name = "<##INFRA_NAME##>-pub"
	}
}

provisioner "local-exec" {
        command = "echo ${self.public_ip} > temp_ip"
    }

resource "aws_internet_gateway" "<##INFRA_NAME##>-igw" {
	vpc_id = "${aws_vpc.<##INFRA_NAME##>-vpc.id}"

	tags = {
		Name = "<##INFRA_NAME##>-igw"
	}
}

resource "aws_security_group" "<##INFRA_NAME##>-SG-WEB" {
	name = "<##INFRA_NAME##>-SG-WEB"
	description = "<##INFRA_NAME##>-SG-WEB"
	vpc_id = "${aws_vpc.<##INFRA_NAME##>-vpc.id}"

	ingress {
		description = "Allow SSH from External"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = []
	}

	ingress {
		description = "Allow HTTP from External"
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = []
	}

	egress {
		description = "Allow out Traffic"
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		ipv6_cidr_blocks = []
	}
}

resource "aws_instance" "<##INFRA_NAME##>-INSTANCE-WEB" {
	key_name = "<##KEY_NAME##>"
	ami = "ami-09e513e9eacab10c1"
	vpc_security_group_ids = ["${aws_security_group.<##INFRA_NAME##>-SG-WEB.id}"]
	subnet_id = "${aws_subnet.<##INFRA_NAME##>-pub.id}"
	instance_type = "t2.micro"
	associate_public_ip_address = "true"
	user_data = user_data = "${file("httpd.sh")}"

	tags = {
		Name = "<##INFRA_NAME##>-INSTANCE-WEB"
	}
}
