env = "dev"
cidr_block = {
  "public_Subnet1"  = "10.0.0.0/24"
  "public_subnet2"  = "10.0.2.0/24"
  "private_subnet1" = "10.0.3.0/24"
}

instance_type = {
  "webserver1" = "t2.micro"
  "webserver2" = "t2.small"
  "webserver3"   = "t2.micro"
}