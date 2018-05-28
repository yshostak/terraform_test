variable "name" {
  default = "test"
}
variable "instance_tenancy" {
    default = "default"
}
variable "assign_generated_ipv6_cidr_block" {
    default = "false"
}
variable "enable_classiclink" {
    default = "false"
}
variable "vpc_cidr" {
    #type = "list" default = []
}
variable "public_subnet_cidrs" {
    type = "list"
    default = []
}
variable "availability_zones" {
    type = "list"
    default = []
}
variable "enable_internet_gateway" {
    default = "false"
}
variable "public_propagating_vgws" {
    default = []
}
variable "map_public_ip_on_launch" {
    default = "true"
}
variable "enable_s3_endpoint" {
    default     = "true"
}
