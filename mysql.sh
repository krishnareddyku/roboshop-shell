source common.sh

MYSQL_REPO

print_head "Install Mysql"
yum install mysql-community-server -y
status_check

print_head "Enable mysql systemD"
systemctl enable mysqld
status_check

print_head "Start Mysql Server"
systemctl start mysqld
status_check

print_head "Reset default database password"
mysql_secure_installation --set-root-pass ${root_mysql_password}
status_check
