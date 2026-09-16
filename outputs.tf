output "vpc_id" {
  value       = aws_vpc.terra_vpc.id
  description = "VPC ID"
}

output "pub_sub_01_id" {
  value       = aws_subnet.terra_vpc_pub_01.id
  description = "ID of terra_vpc_pub_01"
}

output "pub_sub_02_id" {
  value       = aws_subnet.terra_vpc_pub_02.id
  description = "ID of terra_vpc_pub_02"
}

output "priv_sub_01_id" {
  value       = aws_subnet.terra_vpc_priv_01.id
  description = "ID of terra_vpc_priv_01"
}

output "priv_sub_02_id" {
  value       = aws_subnet.terra_vpc_priv_02.id
  description = "ID of terra_vpc_priv_02"
}

output "data_01_id" {
  value       = aws_subnet.terra_vpc_data_01.id
  description = "ID of terra_vpc_data_01"
}

output "data_02_id" {
  value       = aws_subnet.terra_vpc_data_02.id
  description = "ID of terra_vpc_data_02"
}

output "dashboard-lb" {
  value       = aws_lb.dashboard_lb.dns_name
  description = "DNS name of dashboard tier loadbalancer"
}

output "counting-lb" {
  value       = aws_lb.counting_lb.dns_name
  description = "DNS name of counting tier loadbalancer"
}

# output "RDS-endpoint" {
#   value       = aws_db_instance.mysql_rds.endpoint
#   description = "RDS endpoint name"
# }

# output "route_53_alb" {
#   value       = aws_route53_record.www.name
#   description = "Route53 map with web-asg"
# }

output "cloudfront" {
  value = aws_cloudfront_distribution.alb_cf.domain_name
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "amazon_linux_ami_id" {
  value = data.aws_ami.amazon_linux.id
}