script_location="$(pwd)/files"
LOG=/tmp/robohop.log
MONGODB-SERVER-IPADDRESS=localhost
MYSQL-SERVER-IPADDRESS=localhost

exec &>>${LOG}

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

APP_PREREQ() {
  print_head "add roboshop ${component}"
  id roboshop

  if [ $? -eq 0 ];then
     useradd roboshop
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
}

NODEJS() {
  print_head "setup nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash
  status_check
  
  print_head "Install nodeJs"
  yum install nodejs -y
  status_check

  print_head "Load App pre-req"
  APP_PREREQ

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
}

MYSQL_REPO() {

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
}

LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo" ]; then
        print_head "configure mongodb repo file"
        cp "${script_location}/mongo.repo" /etc/yum.repo.d/mongo.repo
        status_check

        print_head "Install mongodb-shell"
        yum install mongodb-org-shell -y
        status_check

        print_head "load mongodb schema"
        mongo --host "${MONGODB-SERVER-IPADDRESS}" </app/schema/${component}.js
        status_check
    fi
      if [ ${schema_type} == "mysql" ]; then
          print_head "Load MySql Repo"
          MYSQL_REPO

          print_head "Install MySql Client"
          yum install mysql-community-client -y
          status_check

          print_head "Reset default database password"
          mysql_secure_installation --set-root-pass ${root_mysql_password}
          status_check

          print_head "Load schema"
          mysql -h ${MYSQL-SERVER-IPADDRESS} -uroot -p${root_mysql_password} < /app/schema/${component}.sql
          status_check
      fi
  fi
}

MAVEN() {

  print_head "Install Maven"
  yum install maven -y
  status_check

  print_head "Load App-prereq"
  APP_PREREQ

  print_head " build a package"
  mvn clean package
  status_check

  print_head "rename and replace shipping.jar"
  mv target/shipping-1.0.jar shipping.jar
  status_check

  print_head "Configure systemD shipping service file"
  cp "${script_location}/shipping.service" /etc/systemd/system/shipping.service
  status_check

  print_head "reload systemD Service"
  systemctl daemon-reload
  status_check

  print_head "Enable systemd shipping service"
  systemctl enable shipping
  status_check

  print_head "start shipping service"
  systemctl start shipping
  status_check

  print_head "Load schema"
  LOAD_SCHEMA
  status_check

}
