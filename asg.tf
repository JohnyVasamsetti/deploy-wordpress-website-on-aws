resource "aws_autoscaling_group" "app-tier-asg" {
  name = "app-tier-workloads"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  vpc_zone_identifier = [aws_subnet.app-tier-sn.id]
  launch_template {
    id = aws_launch_template.app-tier-lt.id
  }
  tag {
    key                 = "Name"
    value               = "app-tier-workload"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "app-tier-lt" {
  key_name = aws_key_pair.instance_key.key_name
  image_id = local.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.app-tier-sg.id]
  user_data = base64encode(file("user_data.sh"))
  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" : "app-tier-workload"
    }
  }
}