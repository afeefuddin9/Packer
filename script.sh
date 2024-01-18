#!/bin/bash
sleep 30
echo "----------------********************************----------------"
echo "Installing Ansible...!"
echo "----------------********************************----------------"
sudo yum update -y
sudo amazon-linux-extras install ansible2 -y
sudo ansible --version >/home/ec2-user/ansible_version.txt

#Installing Nginx
sleep 30
echo "----------------********************************----------------"
echo "Installing Nginx...!"
echo "----------------********************************----------------"
sudo amazon-linux-extras install nginx1 -y
sleep 10
sudo mkdir /etc/nginx/sites-available/
sudo mkdir /etc/nginx/sites-enabled/

#Copying Nginx file from S3 to Site-Available
echo "----------------********************************----------------"
echo "Copying Nginx Files from s3...!"
echo "----------------********************************----------------"
sleep 10
sudo aws s3 cp s3://packer-v1/demo_nginx_files/ /etc/nginx/sites-available/ --recursive
sleep 10
sudo ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/

#Running ansible playbook
sleep 10
sudo ansible-playbook /home/ec2-user/deploy.yml

#Starting the installed packages
echo "----------------********************************----------------"
echo "Starting the Docker & Nginx...!"
echo "----------------********************************----------------"
sudo systemctl start docker
sudo systemctl start nginx
sudo nginx -t
