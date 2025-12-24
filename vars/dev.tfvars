# vars/dev.tfvars

# Add this line (it was missing or misspelled)
environment   = "dev"

# Ensure these are also present
subnet_id     = "subnet-0141cb5b218fa3e5a" 
vpc_id        = "vpc-0fe260f16248ea96b" 
instance_type = "t2.micro" 
instance_name = "Splunk-Server"
aws_region    = "us-east-1"