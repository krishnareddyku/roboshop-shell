files="$(pwd)/files"
echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y
echo -e "\e[35m Remove Nginx Old Content\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[35m Download Frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
echo -e "\e[35m Extract Frontend Content\e[0m"
unzip /tmp/frontend.zip
echo -e "\e[35m update nginx config\e[0m"
cp ${files}/nginx.roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[35m Restart Nginx\e[0m"
systemctl restart nginx
echo -e "\e[35m Enable systemd nginx\e[0m"
systemctl enable nginx