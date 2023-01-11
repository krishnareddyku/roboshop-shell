source common.sh
script_location="$(pwd)/files"

print_head "Install Nginx"
yum install nginx -y
status_check

print_head "Remove Nginx Old Content"
rm -rf /usr/share/nginx/html/*
status_check

print_head "Download Frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
status_check

cd /usr/share/nginx/html || exit

print_head "Extract Frontend Content"
unzip /tmp/frontend.zip
status_check

print_head "update nginx config"
cp "${script_location}/nginx.roboshop.conf" /etc/nginx/default.d/roboshop.conf
status_check

print_head "Restart Nginx"
systemctl restart nginx
status_check

print_head "Enable systemd nginx"
systemctl enable nginx
status_check