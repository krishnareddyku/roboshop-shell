source common.sh

print_head "setup nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash
status_check

print_head "Install nodeJs"
yum install nodejs -y
status_check

print_head "add roboshop user"
id roboshop
if [ $? -eq 0 ];then
   useradd roboshop
fi
status_check

print_head "create /app directory"
mkdir -p /app
status_check

cd /app || exit

print_head "download catalogue content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
status_check

print_head " unzip catalogue content under /app"
unzip /tmp/catalogue.zip
status_check

print_head "Install nodejs dependencies"
npm install
status_check

print_head "reload systemD"
systemctl daemon-reload
status_check

print_head "enable systemd catalogue service"
systemctl enable catalogue
status_check

print_head "start catalogue service"
systemctl start catalogue
status_check

print_head "Configure catalogue service"
catalogue_service_config
status_check

print_head "configure mongodb repo file"
mongo_repo
status_check

print_head "Install mongodb-shell"
yum install mongodb-org-shell -y
status_check

print_head "load mongodb schema"
mongo --host ${MONGODB-SERVER-IPADDRESS} </app/schema/catalogue.js
status_check