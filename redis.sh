source common.sh

print_head "Setup redis repository"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
status_check

print_head "enable redis modules"
dnf module enable redis:remi-6.2 -y
status_check

print_head "Install redis"
yum install redis -y
status_check

print_head "Update redis listen address"
sed -i -e '/127.0.0.1/0.0.0.0/' /etc/redis.conf  /etc/redis/redis.conf
status_check

print_head "Enable systemd redis"
systemctl enable redis
status_check

print_head "Start redis service"
systemctl start redis
status_check


