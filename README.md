# Minecraft Using Terraform


*disclaimer*: I managed this by myself, so I wrote this code for convenience.
It is not complete, and I cannot guarantee its accuracy or security.
It was created for my specific use-case. May it be of reference to you!


## AWS Structure
The terraform is included.
The basic idea is that I had a EC2 instance running at all times. It would sync its backups to an S3.
If I had to use a new instance, then I would sync the files from the S3, and I would start the server from the command line.
The terraform mostly just handles linking the EC2 to the S3.

I was running a modded minecraft server, so I had a large instance allocated.
Feel free to change it.
To reduce costs, I was using a spot-instance strategy.
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html
It is typically cheaper, but that means that there is a chance that your instance will become deallocated.
To combat this, I set `instance_interruption_behaviour` equal to `stop`.
If your instance is deallocated, your ec2 should stop, and then you just have to start it again yourself.
I matched my max spot-price to the on-demand price for my instance-type from this table. https://aws.amazon.com/ec2/pricing/on-demand/
By doing so, it reduces the chance of deallocation because spot instances do not often become as expensive as fixed instances.
In running the server for about 3 months, the instance was never deallocated.

## Management
All actions were done through SSH.
Starting the server for the first time would look like:
- ssh into instance
- sync the s3 and the ec2 instance
- cd to my backups folder (minecraft mod) and start my backup script (sync every `X` amount of time)
- go to the minecraft server folder, and start the server from the command line as a background process (so that it wouldn't terminate when ssh is disconnected)
- enjoy
I created billing alerts through the AWS console to help me track my spending.

## Setup Steps (from what I can think of)
### providers.tf
- set your desired region

### main.tf
- setup ssh-key for terraform to use with aws
  - you might need to allow this on the AWS side...I don't remember 😇

### vpc.tf
- give yourself ssh access on port 22 by adding your ip address (xxx.xxx.xxx.xxx/32) to `resource "aws_security_group" "main"`
- update region name in `resource "aws_subnet" "main"` to desired region


### ec2.tf
- set your instance type
- set your max price for spot instances

### S3.tf
- set name of your bucket in `resource "aws_s3_bucket" "bucket"`
- update region name in `resource "aws_vpc_endpoint" "s3"` to desired region


## Known problems
- Infinitely taking backups means that your S3 will use a lot of memory
  - I would delete old backups manually through the AWS S3 Console, but you can automate this
- The S3 is set to private, but it's always good to double check :)
- most of my scripts just echo some helpful info to the terminal (piping commands wasn't working as well)
  - again, this was a minimum-effort/maximum-reward project (aka lazy) 😇