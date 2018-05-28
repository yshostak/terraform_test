resource "aws_vpc" "vpc" {
    cidr_block                          = "${cidrsubnet(var.vpc_cidr, 0, 0)}"
    instance_tenancy                    = "${var.instance_tenancy}"
    assign_generated_ipv6_cidr_block    = "${var.assign_generated_ipv6_cidr_block}"
    enable_classiclink                  = "${var.enable_classiclink}"
    tags {
        Name            = "${lower(var.name)}-vpc"
    }
}

resource "aws_security_group" "sg" {
    name                = "${var.name}-sg"
    description         = "Security Group ${var.name}-sg"
    vpc_id              = "${aws_vpc.vpc.id}"

    tags {
        Name            = "${var.name}-sg"
    }
    lifecycle {
        create_before_destroy = true
    }
    ingress {
        from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    	from_port       = 0
    	to_port         = 0
    	protocol        = "-1"
    	cidr_blocks     = ["0.0.0.0/0"]
    }
    depends_on  = ["aws_vpc.vpc"]
}

resource "aws_subnet" "public_subnets" {
    count                   = "${length(var.public_subnet_cidrs)}"
    cidr_block              = "${element(var.public_subnet_cidrs, count.index)}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
    availability_zone       = "${element(var.availability_zones, 0)}"
    tags {
        Name            = "public_subnet-${element(var.availability_zones, count.index)}"
    }
    depends_on        = ["aws_vpc.vpc"]
}

resource "aws_internet_gateway" "internet_gw" {
    count = "${length(var.public_subnet_cidrs) > 0 ? 1 : 0}"
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name            = "internet-gateway to ${var.name}-vpc"
    }
    depends_on        = ["aws_vpc.vpc"]
}

resource "aws_route_table" "public_route_tables" {
    count            = "${length(var.public_subnet_cidrs) > 0 ? 1 : 0}"
    vpc_id           = "${aws_vpc.vpc.id}"
    propagating_vgws = ["${var.public_propagating_vgws}"]
    tags {
        Name            = "public_route_tables"
    }
    depends_on        = ["aws_vpc.vpc"]
}

resource "aws_route" "public_internet_gateway" {
    count                  = "${length(var.public_subnet_cidrs) > 0 ? 1 : 0}"
    route_table_id         = "${aws_route_table.public_route_tables.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.internet_gw.id}"
    depends_on             = ["aws_internet_gateway.internet_gw", "aws_route_table.public_route_tables"]
}

resource "aws_route_table_association" "public_route_table_associations" {
    count           = "${length(var.public_subnet_cidrs)}"
    subnet_id       = "${element(aws_subnet.public_subnets.*.id, count.index)}"
    route_table_id  = "${aws_route_table.public_route_tables.id}"
    depends_on      = ["aws_route_table.public_route_tables", "aws_subnet.public_subnets"]
}

data "aws_vpc_endpoint_service" "s3" {
  count = "${var.enable_s3_endpoint ? 1 : 0}"

  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = "${var.enable_s3_endpoint ? 1 : 0}"

  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = "${var.enable_s3_endpoint && length(var.public_subnet_cidrs) > 0 ? 1 : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.public_route_tables.id}"
}

