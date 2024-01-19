variable "vpc_cidr" {
  description = "value of vpc cidr block"
  type        = string
}
variable "public_subnets" {
  description = "subnets CIDR"
  type        = list(string)
}
variable "private_subnets" {
  description = "subnets CIDR"
  type        = list(string)
}
  
