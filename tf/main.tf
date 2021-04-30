resource "aws_key_pair" "aws_tf" {
  key_name   = "aws_tf"
  public_key = file("~/.ssh/xxx/xxx.pub") # SSH CREDENTIAL FOR AWS
}

output "public_ip" {
  value = aws_eip.eip
}
