files="$(pwd)/files"
LOG=/tmp/robohop.log
exec &>>${LOG}

status () {
  if [ $? -eq 0 ];then
    echo SUCESS
    else
    echo -e "\e31mFAILURE\e[0m"
    echo "refer ${LOG} more info"
    exit
  fi
}

echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y
status

echo -e "\e[35m Remove Nginx Old Content\e[0m"
rm -rf /usr/share/nginx/html/*
status

echo -e "\e[35m Download Frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
status

cd /usr/share/nginx/html
status

echo -e "\e[35m Extract Frontend Content\e[0m"
unzip /tmp/frontend.zip
status

echo -e "\e[35m update nginx config\e[0m"
cp ${files}/nginx.roboshop.conf /etc/nginx/default.d/roboshop.conf
status

echo -e "\e[35m Restart Nginx\e[0m"
systemctl restart nginx
status

echo -e "\e[35m Enable systemd nginx\e[0m"
systemctl enable nginx
status