terraform {
  backend "s3" {
    bucket = "eks-terraform-bucket12"
    key    = "EKS_Terraform_Jenkins/.terraform/terraform.tfstate"
    region = "ap-southeast-2"
  }
}
