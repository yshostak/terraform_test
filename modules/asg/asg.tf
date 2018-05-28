resource "aws_elb" "test-elb" {
  name = "test-elb"
  subnets             = ["${var.subnets}"]
    listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

resource "aws_autoscaling_group" "test-asg" {
  name                 = "test-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.test-lc.name}"
  load_balancers       = ["${aws_elb.test-elb.name}"]
  vpc_zone_identifier  = ["${var.vpc_zone_identifier}"]  

  tag {
    key                 = "Name"
    value               = "test-asg"
    propagate_at_launch = "true"
  }
  depends_on            = ["aws_launch_configuration.test-lc"]
}

resource "aws_key_pair" "key_pair" {
  key_name = "${lower(var.key_name)}"
  public_key = "${file("${var.key_path}")}"
  depends_on      = ["aws_iam_role.role"] 
}


resource "aws_launch_configuration" "test-lc" {
  name          = "test-lc"
  image_id      = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.s3-test.arn}"
  security_groups = ["${aws_security_group.asg-sg.id}"]
  user_data       = "${file("${var.userdata_path}")}"
  key_name        = "${var.key_name}"
  
  depends_on      = ["aws_iam_instance_profile.s3-test"]
}

resource "aws_security_group" "asg-sg" {
  name        = "asg_sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "role" {
  name = "s3-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "attachment"
  roles      = ["${aws_iam_role.role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  depends_on      = ["aws_iam_role.role"]
}

resource "aws_iam_instance_profile" "s3-test" {
  name = "s3-test"
  role = "${aws_iam_role.role.name}"
  depends_on      = ["aws_iam_role.role"]
}
