#Note this file needs to be set based on the cloned location of the repo.
REPOS_BASE_DIR="/Users/$(whoami)/Documents/repos"
MAC_SETTINGS_BP_FILE="$REPOS_BASE_DIR/mac_settings/home/.bash_profile"
UTILITY_SCRIPTS_GITDIR_FILE="$REPOS_BASE_DIR/utility_scripts/gitdir.sh"

# Open mac_settings project bash profile file
function vibp {
  vim $MAC_SETTINGS_BP_FILE
}

# Copy mac settings project bash profile file into the users home directory
function cpbp {
  cp $MAC_SETTINGS_BP_FILE ~/.bash_profile
}

# Source the users bash profile file
function sourcebp {
  source ~/.bash_profile
}

# Copy the gitdir.sh script to the current directory
function getgitdir {
  cp $UTILITY_SCRIPTS_GITDIR_FILE gitdir
  chmod +x gitdir
}

# Create a newly stubbed bash script file
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

#For bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
