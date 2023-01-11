source common.sh

print_head "setup nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash

print_head "Install nodeJs"
yum install nodejs -y

print_head "add roboshop user"
useradd roboshop

print_head "create /app directory"
mkdir -p /app
cd /app || exit

print_head "download catalogue content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

print_head " unzip catalogue content under /app"
unzip /tmp/catalogue.zip

print_head "Install nodejs dependencies"
npm install

print_head "reload systemD"
systemctl daemon-reload

print_head "enable systemd catalogue service"
systemctl enable catalogue

print_head "start catalogue service"
systemctl start catalogue

print_head "Configure catalogue service"
catalogue_service_config

print_head "Install mongodb-shell"
yum install mongodb-org-shell -y

print_head "load mongodb schema"
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js