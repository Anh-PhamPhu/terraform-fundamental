provider "aws" {
    
    region = "ap-northeast-1"
    access_key = "AKIAXYR45CLDGWGGG4WR"
    secret_key = "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"
}

# //Create resource EC2_instance
# # resource "aws_instance" "myTerraFormTest" {
# #     ami = "ami-0cff7528ff583bf9a"
# #     instance_type = "t2.micro"
# #     tags = {
# #         Name = "my-terraform-test"
# #     }
# # } 

# # To destroy resource -> comment this code



# # resource "<provider>_<resource_type>" "name" {
# #     config options....
# #     key = "value"
# #     key2 = "another Value"
# # }

# # # Create VPC in terra
# # resource "aws_vpc" "terraform-vpc" {
# #     cidr_block = "192.168.0.0/16"
# #     tags = {
# #         Name : "custom-vpc-for-terraform"
# #     }
# # }
# # resource "aws_subnet" "subnet-1" {
# #     vpc_id = aws_vpc.terraform-vpc.id 
# #     cidr_block = "192.168.1.0/24"
# #     tags = {
# #         Name : "custom-vpc-for-terraform-subnet-1"
# #     }
# # }

# ### Practice

# # 1. Create VPC
# resource "aws_vpc" "my-tokyo-custom-vpc" {
#     cidr_block = "10.0.0.0/16"
#     tags = {
#         Name : "my-tokyo-custom-vpc"
#     }
# }
# # # 2. Cretae Internetgateway 
# resource "aws_internet_gateway" "my-custom-igw" {
#     vpc_id = aws_vpc.my-tokyo-custom-vpc.id
# }
# # # 3. Create Custom Route Table
# resource "aws_route_table" "my-custom-main-RT" {
#     vpc_id = aws_vpc.my-tokyo-custom-vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.my-custom-igw.id
#     }

#     # route {
#     #     ipv6_cidr_block = "::/0"
#     #     egress_only_gateway_id = aws_internet_gateway.my-custom-igw.id
#     # }

#     tags = {
#         Name : "my-custom-main-RT"
#     }
# }
# # # 4. Cretae A Subnet 
# # ### 2 Subnet in public-subnet-1a
# resource "aws_subnet" "public-subnet-1a" {
#     vpc_id = aws_vpc.my-tokyo-custom-vpc.id

#     cidr_block = "10.0.1.0/24"
#     availability_zone = "ap-northeast-1a"
#     map_public_ip_on_launch = true

#     tags = {
#         Name : "public-subnet-1a"
#     }
# }
# # # resource "aws_subnet" "private-subnet-1a" {
# # #     vpc_id = my-tokyo-custom-vpc.id

# # #     cidr_block = "10.0.0.2/24"
# # #     availability_zone = "ap-northeast-1a"

# # #     tags = {
# # #         Name : "private-subnet-1a"
# # #     }
# # # }
# # # ### 2 Subnet in public-subnet-1b
# # # resource "aws_subnet" "public-subnet-1b" {
# # #     vpc_id = my-tokyo-custom-vpc.id

# # #     cidr_block = "10.0.0.1/32"
# # #     availability_zone = "ap-northeast-1b"
# # #     map_public_ip_on_launch = true

# # #     tags = {
# # #         Name : "public-subnet-1b"
# # #     }
# # # }
# # # resource "aws_subnet" "private-subnet-1b" {
# # #     vpc_id = my-tokyo-custom-vpc.id

# # #     cidr_block = "10.0.0.2/32"
# # #     availability_zone = "ap-northeast-1b"

# # #     tags = {
# # #         Name : "private-subnet-1b"
# # #     }
# # # }

# variable  "subnet-prefix"{
#     description = "Hello"

# }
# # # 5. Associate Subnet With Route Table
# # ### Main route table for pubic subnet 
# resource "aws_route_table_association" "a" {
#     subnet_id = aws_subnet.public-subnet-1a.id
#     route_table_id = aws_route_table.my-custom-main-RT.id
# }
# # # resource "aws_route_table_association" "a-1" {
# # #     subnet_id = aws_subnet.public-subnet-1b.id
# # #     route_table_id = aws_route_table.my-custom-main-RT.id
# # # }
# # # 6. Create Sercurity Group To Allow Port 22, 80, 443
# resource "aws_security_group" "web-access" {
#     name        = "web-access"
#     description = "Allow Port 22, 80, 443"
#     vpc_id      = aws_vpc.my-tokyo-custom-vpc.id
#     //Inbound rules
#     ingress {
#         description      = "HTTPS"
#         from_port        = 443
#         to_port          = 443
#         protocol         = "tcp"
#         cidr_blocks      = ["0.0.0.0/0"]
#         ipv6_cidr_blocks = ["::/0"]
#     }
#     ingress {
#         description      = "HTTP"
#         from_port        = 80
#         to_port          = 80
#         protocol         = "tcp"
#         cidr_blocks      = ["0.0.0.0/0"]
#         ipv6_cidr_blocks = ["::/0"]
#     }
#     ingress {
#         description      = "SSH"
#         from_port        = 22
#         to_port          = 22
#         protocol         = "tcp"
#         cidr_blocks      = ["0.0.0.0/0"]
#         ipv6_cidr_blocks = ["::/0"]
#     }
#     //Outbound Rules
#     egress {
#         from_port        = 0
#         to_port          = 0
#         protocol         = "-1"
#         cidr_blocks      = ["0.0.0.0/0"]
#         ipv6_cidr_blocks = ["::/0"]
#     }

#     tags = {
#         Name = "web-access"
#     }
# }
# # # 7. Create a network interface with an ip in the subnet that was created in step 4
# resource "aws_network_interface" "web-server-nic" {
#     subnet_id = aws_subnet.public-subnet-1a.id
#     private_ips = ["10.0.1.50"]
#     security_groups = [aws_security_group.web-access.id]
# }
# # # 8. Assign an elastic IP to network interface created in step 7
# resource "aws_eip" "my-eip" {
#     vpc = true
#     network_interface = aws_network_interface.web-server-nic.id
#     associate_with_private_ip = "10.0.1.50"
#     depends_on = [aws_internet_gateway.my-custom-igw]
# }
# # # 9. Create linux server install/enable httpd-apache2
# resource "aws_instance" "my-custom-instance"{
#     ami = "ami-0b7546e839d7ace12"
#     instance_type = "t2.micro"
#     availability_zone = "ap-northeast-1a"
#     key_name = "tokyo-keypair"

#     network_interface  {
#         device_index = 0
#         network_interface_id = aws_network_interface.web-server-nic.id
#     }

#     user_data = <<-EOF
#                 #!/bin/bash
#                 yum update -y
#                 yum install httpd -y
#                 systemctl start httpd
#                 systemctl enable httpd
#                 echo bash -c "echo your 1st webserver with terraform" > /var/www/html/index.html
#                 EOF
#     tags = {
#         Name : "my-custom-instance"
#     }
# }

