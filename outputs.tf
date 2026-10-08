output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

output "s3_bucket_details" {
  value = aws_s3_bucket.example.tags
}

# output "subnet_ids"{
#   value = aws_subnet.demo_subnet[*].id
# }

# output "subnet_tag"{
#   value = aws_subnet.demo_subnet[*].tags.Name
# }