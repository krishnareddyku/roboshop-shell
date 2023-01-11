files="$(pwd)/files"
echo -e "\e[35m execute nodejs repo\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[35m Install nodejs\e[0m"
yum install nodejs -y
useradd roboshop
mkdir /app
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
cp $files/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js
