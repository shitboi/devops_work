###awscli 
--endpoint http://aws:4566
export TF_LOG
export TF_LOG_PATH=/tmp/terraform.logs

The command used to create this key is 
aws ec2 create-key-pair --endpoint http://aws:4566 --key-name jade --query 'KeyMaterial' --output text > /root/terraform-projects/project-jade/jade.pem.

#using jq filters
aws ec2 describe-instances --endpoint http://aws:4566 
--filters "Name=image-id,Values=ami-082b3eca746b12a89" 
|jq -r '.Reservations[].Instances[].InstanceId'

##module
module "payroll_app" {
  source = "/root/terraform-projects/modules/payroll-app"
  app_region = lookup(var.region, terraform.workspace)
  ami = lookup(var.ami, terraform.workspace)
  
}

https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-user

module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "3.4.0"
  # insert the 1 required variable here
  name = "max"
  create_iam_access_key = "false"
  create_iam_user_login_profile = "false"


###Terraform
#provider.tf
provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://aws:4566"
  }
}

#variable.tf
variable "ami" {
  type = string
  default = "ami-06178cf087598769c"
}
variable "region" {
    type = string
    default = "eu-west-2"
  
}
variable "instance_type" {
    type = string
    default = "m5.large"
  
}

#main.tf
resource "aws_instance" "cerberus" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.cerberus-key.id
  user_data = file("/root/terraform-projects/project-cerberus/install-nginx.sh")
}
resource "aws_key_pair" "cerberus-key" {
    key_name = "cerberus"
    public_key = file("/root/terraform-projects/project-cerberus/.ssh/cerberus.pub")
  
}
resource "aws_eip" "eip" {
    vpc = "true"
    instance = aws_instance.cerberus.id
    provisioner "local-exec" {
        command = "echo ${aws_eip.eip.public_dns} > /root/cerberus_public_dns.txt"
    }
}



#create iam user
resource "aws_iam_user" "users" {
    name = "mary" 
}

#terraform state commands
terraform state [show,list,mov,pull,rm,] resource.attribute
e.g   terraform state list aws_s3_bucket.finance
terraform state show [ aws_s3_bucket]
terraform state mv aws_s3_bucket.finance aws_s3_bucket.HR
terraform state pull #pulls terraform.ftstate from remote

terraform state pull |jq ".resources[] |select(.name == "state-locking-db") 
|.instances[].attributes.hash_key"
