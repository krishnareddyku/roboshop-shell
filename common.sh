script_location="$(pwd)/files"
LOG=/tmp/robohop.log
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
echo $script_location >/dev/null