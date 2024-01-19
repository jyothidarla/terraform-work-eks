variable "vpc_cidr" {
  description = "value of vpc cidr block"
  type        = string
}
variable "public_subnets" {
  description = "subnets CIDR"
  type        = list(string)
}
variable "instance_type" {
  description = " instnce type"
  type        = string
}
variable "key_pair" {
  description = "keypair"
  type        = string
}
