#Note this file needs to be set based on the cloned location of the repo.
REPOS_BASE_DIR="/Users/$(whoami)/Documents/repos"
MAC_SETTINGS_BP_FILE="$REPOS_BASE_DIR/mac_settings/home/.bash_profile"
MAC_SETTINGS_INSTALL_TOOLS_FILE="$REPOS_BASE_DIR/mac_settings/setup/install_tools.sh"
UTILITY_SCRIPTS_GITDIR_FILE="$REPOS_BASE_DIR/utility_scripts/gitdir.sh"

alias ll="ls -la"
alias untar='tar -zxvf '
alias speed='speedtest-cli --server 2406 --simple'
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipe='curl ipinfo.io/ip'
alias ipi='ipconfig getifaddr en0'
alias getweather="curl -4 http://wttr.in/chicago"

alias cdrepos="cd $REPOS_BASE_DIR"
alias assume="unset AWS_SHARED_CREDENTIALS_FILE; /Users/$(whoami)/Documents/repos/utility_scripts/aws-assume-role/assume_role.sh --adid=$(whoami) --region=us-east-1 --role=AdminRole --accounts=xxxxxxxxxxxx;export AWS_SHARED_CREDENTIALS_FILE=$(ls | grep awscreds)"
alias assume2="unset AWS_SHARED_CREDENTIALS_FILE; /Users/$(whoami)/Documents/repos/utility_scripts/aws-assume-role/assume_role.sh --adid=$(whoami) --region=us-east-1 --role= AdminRole --accounts= xxxxxxxxxxxx;export AWS_SHARED_CREDENTIALS_FILE=$(ls | grep awscreds)"
alias awsacctalias="aws iam list-account-aliases | jq -r \".AccountAliases[0]\""

alias setcreds="export AWS_SHARED_CREDENTIALS_FILE=$(ls | grep awscreds)"
alias unsetcreds="unset AWS_SHARED_CREDENTIALS_FILE"
alias checkcreds="printenv | grep AWS_SHARED_CREDENTIALS_FILE"
alias sshbastion="ssh -i ~/.ssh/id_rsa ubuntu@SOMEIPADDRESSS"

alias tfinitrm="rm -rf .terraform;unset AWS_SHARED_CREDENTIALS_FILE;rm awscreds*;rm *tfstate*"

function tfdo {
  local -r tf_do_current_dir="${PWD##*/}"
  local -r tf_do_action=$1
  local tf_do_var_file="terraform.tfvars"
  local tf_do_cmd_switch="var-file"
  if [ "init" == "$1" ]; then
    tf_do_var_file="backend.tfvars"
    tf_do_cmd_switch="backend-config"
  fi
  echo "tfdo "$1" -$tf_do_cmd_switch=../env/$2/$tf_do_var_file" "-$tf_do_cmd_switch=../env/$2/$tf_do_current_dir/$tf_do_var_file"
  terraform "$1" "-$tf_do_cmd_switch=../env/$2/$tf_do_var_file" "-$tf_do_cmd_switch=../env/$2/$tf_do_current_dir/$tf_do_var_file"
}


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

# Open mac_settings project install_tools.sh script for editing
function viit {
  vi $MAC_SETTINGS_INSTALL_TOOLS_FILE
}

# Run the install_tools.sh script in the mac_settings project
function doit {
  bash -c $MAC_SETTINGS_INSTALL_TOOLS_FILE
}

# Copy the gitdir.sh script to the current directory
function cpgitdir {
  cp $UTILITY_SCRIPTS_GITDIR_FILE gitdir
  chmod +x gitdir
}

function mknote {
    touch "$(date '+%Y%m%d')-notes.txt"
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
export PATH="/usr/local/opt/libressl/bin:/usr/local/opt/curl/bin:$PATH"

#For bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
