output "instance_tenancy" {
    value = "${aws_vpc.vpc.instance_tenancy}"
}
output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}
output "vpc_cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}
output "default_network_acl_id" {
    value = "${aws_vpc.vpc.default_network_acl_id}"
}
output "security_group_id" {
    value = "${aws_security_group.sg.id}"
}
output "default_security_group_id" {
    value = "${aws_vpc.vpc.default_security_group_id}"
}
output "public_route_table_ids" {
    value = ["${aws_route_table.public_route_tables.*.id}"]
}
output "vpc-publicsubnets" {
    value = "${aws_subnet.public_subnets.*.cidr_block}"
}
output "vpc-publicsubnet-id_0" {
    value = "${aws_subnet.public_subnets.0.id}"
}
output "vpc-publicsubnet-ids" {
    value = "${aws_subnet.public_subnets.*.id}"
}
output "gateway_id" {
  value = "${element(concat(aws_internet_gateway.internet_gw.*.id, list("")), 0)}"
}
