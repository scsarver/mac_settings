function newsh {
  echo "#!/usr/bin/env bash" > new.sh
  echo "#" >> new.sh
  echo "# Created By: $(whoami)" >> new.sh
  echo "# Created Date: $(date +%Y%m%d-%H%M%S)" >> new.sh
  echo "#" >> new.sh
  echo "set -o errexit" >> new.sh
  echo "set -o nounset" >> new.sh
  echo " " >> new.sh
  chmod 740 new.sh
}

#https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
PS1="\D{%Y.%m.%d-%H:%M:%S}|\w:"
export EDITOR=vim
alias grep="grep --color=auto"

#For bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
