terraform {
  required_version = "> 0.10.0"
}
provider "aws" {
    region = "us-west-2"
    shared_credentials_file = "${pathexpand("~/.aws/credentials")}"
}
module "s3" {
    source = "modules/s3"
    name = "testmys3-2000"
    s3_acl = "private"
    region = "us-west-2"
    force_destroy = "true"
}
module "vpc" {
    source = "modules/vpc"
    name = "testmyvpc-2000"
    enable_s3_endpoint = "true"
    assign_generated_ipv6_cidr_block = "false"
    enable_classiclink = "false"
    vpc_cidr = "172.32.0.0/16"
    public_subnet_cidrs = ["172.32.0.0/20"]
    public_subnet_cidrs = ["172.32.16.0/20"]
    availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
    enable_internet_gateway = "true"
}
module "asg" {
    source = "modules/asg"
    subnets = ["${element(module.vpc.vpc-publicsubnet-ids, 0)}"]
    vpc_zone_identifier = ["${module.vpc.vpc-publicsubnet-ids}"]
    vpc_id = "${module.vpc.vpc_id}"
}
