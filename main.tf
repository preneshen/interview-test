#create S3 bucket
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

# resource "aws_instance" "exampleInstance"{
#     ami = 
#     instance_type = "t2.micro"
#     subnet_id =
#     privtae_ip = 
#     tags = {
#         Environment = var.env
#     }
# }

resource "aws_instance" "web-server1" {

  ami           = "ami-0b6d9d3d33ba97d99"
  for_each      = var.instance_type
  instance_type = each.value
  tags = {
    Environment = var.env
    Name        = each.key
  }

  depends_on = [aws_vpc.demo_vpc]
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = var.env
    Name        = "${var.env}-VPC"
  }

  lifecycle {
    create_before_destroy = true

  }
}

resource "aws_subnet" "demo_subnet" {
  # count      = length(var.cidr_block)
  for_each   = var.cidr_block
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = each.value

  tags = {
    Name = "Demo_Subnet-${each.key}"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }

}

# resource "aws_subnet" "main" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Main"
#   }
# }



resource "aws_s3_bucket" "example" {
  bucket = "prengov-my-tf-test-bucket"

  tags = {
    Name        = "${var.env}-Bucket"
    Environment = var.env
    VPCID       = aws_vpc.demo_vpc.id
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each          = var.cidr_block
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = each.value
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}









