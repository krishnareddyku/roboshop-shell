script_location="$(pwd)/files"
LOG=/tmp/robohop.log

status_check () {
  if [ $? -eq 0 ];then
    echo -e "\e31mSUCCESS\e[0m"
    else
    echo -e "\e31mFAILURE\e[0m"
    echo "refer ${LOG} more info"
    exit
  fi
}