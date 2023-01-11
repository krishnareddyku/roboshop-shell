script_location="$(pwd)/files"
LOG=/tmp/robohop.log
exec &>>${LOG}

echo $script_location >/dev/null

status_check () {
  if [ $? -eq 0 ];then
    echo -e "\e[1;31mSUCCESS\e[0m"
    else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "refer ${LOG} more info"
    exit
  fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

mongo_repo() {
  [mongodb-org-4.2]
  name=MongoDB Repository
  baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
  gpgcheck=0
  enabled=1
}

catalogue_service_config() {
  [Unit]
  Description = Catalogue Service

  [Service]
  User=roboshop
  Environment=MONGO=true
  Environment=MONGO_URL="mongodb://<MONGODB-SERVER-IPADDRESS>:27017/catalogue"
  ExecStart=/bin/node /app/server.js
  SyslogIdentifier=catalogue

  [Install]
  WantedBy=multi-user.target
}