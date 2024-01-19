#VPC//use terraform vpc existing modules
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc" //for the cidr we are making use of variable.
  cidr = var.vpc_cidr
  azs  = data.aws_availability_zones.azs.names
  //private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] we wont use it.
  public_subnets = var.public_subnets

  enable_dns_hostnames = true

  tags = {
    name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name = "jenkins-public-subnet"
  }
}
//the rest of the things(IGW,RT) are automatically created, everything is done for us with this particular module.Dont define, it gets auto matically created for us


#SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security group for jenkins-server "
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "jenkins-sg"
  }
}
#EC2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type               = var.instance_type
  key_name                    = aws_key_pair.test.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = base64encode(file("jenkins.sh"))
  availability_zone           = data.aws_availability_zones.azs.names[0]
  tags = {
    Name        = "jenkins-server"
    Terraform   = "true"
    Environment = "dev"
  }
}
resource "aws_key_pair" "test" {
  key_name   = "keys"
  public_key = var.key_pair

}
