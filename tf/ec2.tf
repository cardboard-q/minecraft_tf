data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }

 owners = ["amazon"]
}

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3_profile"
  role = aws_iam_role.s3_role.name
}

resource "aws_spot_instance_request" "ec2" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = "m5a.large" # CHANGE THIS BASED ON DESIRED SIZE

  spot_price = "0.086" # MAX SPOT PRICE
  wait_for_fulfillment = true
  spot_type = "persistent" # default
  instance_interruption_behaviour = "stop"
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.aws_tf.id
  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  iam_instance_profile = aws_iam_instance_profile.s3_profile.id
}
