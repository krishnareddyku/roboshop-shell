script_location="$(pwd)/files"
LOG=/tmp/robohop.log
MONGODB-SERVER-IPADDRESS=localhost
exec &>>${LOG}

echo "$script_location" >/dev/null

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

NODEJS() {
  source common.sh
  
  print_head "setup nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash
  status_check
  
  print_head "Install nodeJs"
  yum install nodejs -y
  status_check
  
  print_head "add roboshop ${component}"
  id roboshop
  if [ $? -eq 0 ];then
     ${component}add roboshop
  fi
  status_check
  
  print_head "create /app directory"
  mkdir -p /app
  status_check
  
  cd /app || exit
  
  print_head "download ${component} content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  status_check
  
  print_head " unzip ${component} content under /app"
  unzip /tmp/${component}.zip
  status_check
  
  print_head "Install nodejs dependencies"
  npm install
  status_check
  
  print_head "reload systemD"
  systemctl daemon-reload
  status_check
  
  print_head "enable systemd ${component} service"
  systemctl enable ${component}
  status_check
  
  print_head "start ${component} service"
  systemctl start ${component}
  status_check
  
  print_head "Configure ${component} service"
  cp "${script_location}/${component}.service" /etc/systemd/system/${component}.service
  status_check
  
  print_head "configure mongodb repo file"
  cp "${script_location}/mongo.repo" /etc/yum.repo.d/mongo.repo
  status_check
  
  print_head "Install mongodb-shell"
  yum install mongodb-org-shell -y
  status_check
  
  print_head "load mongodb schema"
  mongo --host "${MONGODB-SERVER-IPADDRESS}" </app/schema/${component}.js
  status_check
}