source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "export root_mysql_password=<new-password> ; then run sudo -E bash mysql.sh"
  exit
fi

print_head "Disable mysql default module load"
dnf module disable mysql -y
status_check

print_head "Copy mysql repo file"
cp "${script_location}/mysql.repo" /etc/yum.repos.d/mysql.repo
status_check

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
