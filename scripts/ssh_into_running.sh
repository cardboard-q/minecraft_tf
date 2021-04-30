ipaddr=$(aws ec2 describe-instances --filters Name=instance-state-code,Values=16 --query Reservations[*].Instances[*].[PublicIpAddress] --output text)
echo -e "ssh -i ~/.ssh/keys/aws ec2-user@$ipaddr"