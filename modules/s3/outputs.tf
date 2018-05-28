output "bucket_ids" {
    description = "bucket_id"
    value = "${aws_s3_bucket.s3_bucket.*.id}"
}
output "bucket_arns" {
    value = "${aws_s3_bucket.s3_bucket.*.arn}"
}
output "bucket_domain_names" {
    value = "${aws_s3_bucket.s3_bucket.*.bucket_domain_name}"
}
