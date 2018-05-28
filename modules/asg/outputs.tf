output "security_group" {
  value = "${aws_security_group.asg-sg.id}"
}

output "launch_configuration" {
  value = "${aws_launch_configuration.test-lc.id}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.test-asg.id}"
}

output "elb_name" {
  value = "${aws_elb.test-elb.dns_name}"
}
