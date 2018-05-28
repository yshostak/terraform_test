variable "name" {
  default = "test"
}
variable "region" {
  default = "us-west-2"
}
variable "s3_acl" {
    default = "private"
}
variable "force_destroy" {
    default = false
}
variable "enable_lifecycle_rule" {
    default = true
}
variable "lifecycle_rule_prefix" {
    default = ""
}
