DRAGONSHELL_showScriptName()
{
  echo -e "\n\n\033[33m$(for i in $(seq 1 100); do echo -n "=";done)\n$0\n$(for i in $(seq 1 100); do echo -n "=";done)\033[0m"
}

DRAGONSHELL_kill_ifrunning()
{
  PID=$(ps | grep $1 | grep -v grep | sed -n '1p' | awk '{printf $1}')
  if [ "${PID}" != "" ]; then echo "Killing $1 (pid ${PID})"; kill -9 ${PID}; fi
}


