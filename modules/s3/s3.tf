resource "aws_s3_bucket" "s3_bucket" {
    bucket = "${lower(var.name)}"
    region = "${var.region}"
    acl = "${var.s3_acl}"
    force_destroy = "${var.force_destroy}"
    tags {
        Name = "${lower(var.name)}"
    }
    lifecycle {
        create_before_destroy = true
    }
}
