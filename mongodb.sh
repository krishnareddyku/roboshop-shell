files="$(pwd)/files"
echo -e "\e[35m added mongodb.repo\e[0m"
cp $files/mongodb.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[35m Install mongodb\e[0m"
yum install mongodb-org -y
echo -e "\e[35m Enabled systemd mongod\e[0m"
systemctl enable mongod
systemctl start mongod
echo -e "\e[35m update listen address in mongod config\e[0m"
sed -i -e '/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo -e "\e[35m start mongodb\e[0m"
systemctl start mongod
