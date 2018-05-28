variable "aws_region" {
  default     = "us-west-2"
}

variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-7f675e4f"
  }
}

variable "availability_zones" {
  default     = "us-west-2a,us-west-2b,us-west-2c"
}

variable "key_path" {
  default = "/root/.ssh/test.pub"
}

variable "userdata_path" {
  default = "modules/asg/install_nginx.sh"
}

variable "key_name" {
  default     = "test-key"
}

variable "instance_type" {
  default     = "t2.micro"
}

variable "asg_min" {
  default     = "3"
}

variable "asg_max" {
  default     = "3"
}

variable "asg_desired" {
  default     = "3"
}

variable "vpc_zone_identifier" {
    type = "list"
}

variable "subnets" {
    type = "list"
}

variable "vpc_id" {
}
