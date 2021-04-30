s3_base_url="s3://minecraft_s3" # NAME OF BUCKET
while sleep 1;
do sudo aws s3 sync . "${s3_base_url}";
done