variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "Dev"
}

variable "cidr_block" {
    type = map(string)
    default = {}
    nullable = false
  
 
}

variable "instance_type"{
    type = map(string)
    default = {}
    nullable = false
}