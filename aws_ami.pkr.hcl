packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "ami_id" {
  type    = string
  default = "ami-0427f06786dd701e4"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

variable "vpc_id" {
  type    = string
  default = "vpc-09b80355eeeec8c00"
}

variable "subnet_id" {
  type    = string
  default = "subnet-018e7efa0bea73082"
}

variable "iam_role" {
  type    = string
  default = "aws-a0001-aps1-1a-t-rol-onsy-onsy-jenkinsrole"
}



# Source Builder
source "amazon-ebs" "amazon-linux" {
  ami_name             = "amazon-packer-linux-aws-{{timestamp}}"
  instance_type        = "${var.instance_type}"
  source_ami           = "${var.ami_id}"
  region               = "${var.region}"
  ssh_username         = "${var.ssh_username}" 
  vpc_id               = "${var.vpc_id}"
  subnet_id            = "${var.subnet_id}"
  iam_instance_profile = "${var.iam_role}"
}

#Building the source
build {
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]


  #Copy file provisioner to remote
  provisioner "file" {
    source      = "./deploy.yml"
    destination = "/home/ec2-user/deploy.yml"
  }

  # Provisioners run shell script
  provisioner "shell" {
    script = "./script.sh"
  }

  #Post-Process
  post-processor "shell-local" {
    inline = ["echo 'AMI Build Completed...!'"]
  }


}






