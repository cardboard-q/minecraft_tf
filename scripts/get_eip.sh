aws ec2 describe-addresses --filters Name=domain,Values=vpc \
--query Addresses[*].[PublicIp] --output text
