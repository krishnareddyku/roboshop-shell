source common.sh

print_head "configure mongodb repo file"
mongo_repo
status_check

print_head "Install mongodb"
yum install mongodb-org -y
status_check

print_head "Enabled systemd mongod"
systemctl enable mongod
status_check

print_head "update listen address in mongod config"
sed -i -e '/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check

print_head "start mongodb"
systemctl start mongod
status_check
