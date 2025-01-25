#terraform.tfvars

aws_region         = "ap-south-1"
vpc_cidr           = "172.18.0.0/16"
vpc_name           = "MyVPC-TF-Functions-Demo"
key_name           = "DevOps-TerraformPractice"
azs                = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_cidr_block  = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24", "172.18.4.0/24", "172.18.5.0/24", "172.18.6.0/24"]
private_cidr_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24", "172.18.40.0/24", "172.18.50.0/24", "172.18.60.0/24"]
environment        = "Dev"
ingress_value      = ["80", "22", "443", "8080", "3306", "1900"]
