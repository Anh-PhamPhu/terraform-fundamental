provider "aws" {

    region = "us-east-1"
    access_key = "AKIAXYR45CLDGWGGG4WR"
    secret_key = "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"
}

//Create resource EC2_instance
# resource "aws_instance" "myTerraFormTest" {
#     ami = "ami-0cff7528ff583bf9a"
#     instance_type = "t2.micro"
#     tags = {
#         Name = "my-terraform-test"
#     }
# } 

# To destroy resource -> comment this code



# resource "<provider>_<resource_type>" "name" {
#     config options....
#     key = "value"
#     key2 = "another Value"
# }

# # Create VPC in terra
# resource "aws_vpc" "terraform-vpc" {
#     cidr_block = "192.168.0.0/16"
#     tags = {
#         Name : "custom-vpc-for-terraform"
#     }
# }
# resource "aws_subnet" "subnet-1" {
#     vpc_id = aws_vpc.terraform-vpc.id 
#     cidr_block = "192.168.1.0/24"
#     tags = {
#         Name : "custom-vpc-for-terraform-subnet-1"
#     }
# }