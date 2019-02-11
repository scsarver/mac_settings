#Note this file needs to be set based on the cloned location of the repo.
REPOS_BASE_DIR="/Users/$(whoami)/Documents/repos"
MAC_SETTINGS_BP_FILE="$REPOS_BASE_DIR/mac_settings/home/.bash_profile"
MAC_SETTINGS_INSTALL_TOOLS_FILE="$REPOS_BASE_DIR/mac_settings/setup/install_tools.sh"
UTILITY_SCRIPTS_GITDIR_FILE="$REPOS_BASE_DIR/utility_scripts/gitdir.sh"
ONELOGIN_CREDS_LOCATION="$REPOS_BASE_DIR/onelogin-python-aws-assume-role/src/onelogin/aws-assume-role"

ONELOGIN_ODIN_CREDS_LOCATION="$REPOS_BASE_DIR/opploans/opploans-iac/iac-tools/onelogin"
ONELOGIN_ODIN_ASSUME_SCRIPT_NAME="aws-assume-role.py"

ASSUME_USER="xxxxx"
ASSUME_REGION="xxxxx"
ASSUME_ROLE="xxxxx"

alias ll="ls -la"
alias untar='tar -zxvf '
alias speed='speedtest-cli --server 2406 --simple'
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipe='curl ipinfo.io/ip'
alias ipi='ipconfig getifaddr en0'
alias getweather="curl -4 http://wttr.in/chicago"

alias cdrepos="cd $REPOS_BASE_DIR"
alias cdonelog="cd $ONELOGIN_CREDS_LOCATION"

alias assume="unset AWS_SHARED_CREDENTIALS_FILE; $REPOS_BASE_DIR/utility_scripts/aws-assume-role/assume_role.sh --adid=$ASSUME_USER --region=$ASSUME_REGION --role=$ASSUME_ROLE --accounts=473830466053;export AWS_SHARED_CREDENTIALS_FILE=awscreds_473830466053"
alias assume2="unset AWS_SHARED_CREDENTIALS_FILE; $REPOS_BASE_DIR/utility_scripts/aws-assume-role/assume_role.sh --adid=$ASSUME_USER --region=$ASSUME_REGION --role=$ASSUME_ROLE --accounts=625238849455;export AWS_SHARED_CREDENTIALS_FILE=awscreds_625238849455"

alias assume3="unset AWS_SHARED_CREDENTIALS_FILE; $REPOS_BASE_DIR/utility_scripts/aws-assume-role/assume_role.sh --adid=$ASSUME_USER --region=$ASSUME_REGION --role=admin --accounts=516284081414;export AWS_SHARED_CREDENTIALS_FILE=awscreds_516284081414"

alias assumelg="unset AWS_SHARED_CREDENTIALS_FILE; $REPOS_BASE_DIR/utility_scripts/aws-assume-role/assume_role.sh --adid=$ASSUME_USER --region=$ASSUME_REGION --role=$ASSUME_ROLE --accounts=428062593321;export AWS_SHARED_CREDENTIALS_FILE=awscreds_428062593321"


alias awsacctalias="aws iam list-account-aliases | jq -r \".AccountAliases[0]\""
alias awsgetcaller="aws sts get-caller-identity"
alias awsoneloginconfig="vim $REPOS_BASE_DIR/opploans/opploans-iac/iac-tools/onelogin/onelogin.sdk.json"

function awsonelogin {
    python "$ONELOGIN_ODIN_CREDS_LOCATION/$ONELOGIN_ODIN_ASSUME_SCRIPT_NAME"
}

function awsoneloginset {
    export AWS_SHARED_CREDENTIALS_FILE="$(cat $ONELOGIN_ODIN_CREDS_LOCATION/onelogin.sdk.json | jq -r '.aws_shared_credentials_file')"
    export AWS_PROFILE="$(cat $ONELOGIN_ODIN_CREDS_LOCATION/onelogin.sdk.json | jq -r '.aws_profile')"
    export AWS_REGION="$ASSUME_REGION"
}


function awssetcreds {
    export AWS_SHARED_CREDENTIALS_FILE="$1"
}

function awssetprofile {
    export AWS_PROFILE="$1"
}

function setcreds {
    export AWS_SHARED_CREDENTIALS_FILE="$(ls | grep awscreds)"
}

alias unsetcreds="unset AWS_SHARED_CREDENTIALS_FILE"
alias checkcreds="printenv | grep AWS_SHARED_CREDENTIALS_FILE"
alias unsetprofile="unset AWS_PROFILE"
alias checkprofile="printenv | grep AWS_PROFILE"

alias sshbastion="ssh -i ~/.ssh/id_rsa ubuntu@SOMEIPADDRESSS"

alias tfinitrm="rm -rf .terraform;unset AWS_SHARED_CREDENTIALS_FILE;rm awscreds*;rm *tfstate*"
alias awswhoami="aws sts get-caller-identity"


function tfdo_old {
  local -r tf_do_current_dir="${PWD##*/}"
  local -r tf_do_action=$1
  local tf_do_var_file="terraform.tfvars"
  local tf_do_cmd_switch="var-file"
  if [ "init" == "$1" ]; then
    rm -rf .terraform
    tf_do_var_file="backend.tfvars"
    tf_do_cmd_switch="backend-config"
  fi
  local base_var_file_cmd="-$tf_do_cmd_switch=../env/$2/$tf_do_var_file"
  local nested_var_file_cmd=""
  if [ -f "../env/$2/$tf_do_current_dir/$tf_do_var_file" ]; then
    local nested_var_file_cmd="-$tf_do_cmd_switch=../env/$2/$tf_do_current_dir/$tf_do_var_file"
    echo "tfdo_old "$1" $base_var_file_cmd" "$nested_var_file_cmd"
    terraform "$1" "$base_var_file_cmd" "$nested_var_file_cmd"
  else
    echo "tfdo_old "$1" $base_var_file_cmd"
    terraform "$1" "$base_var_file_cmd"
  fi
}


# The tfdo function is used to encapsulate the command line parameters to include the correct tfvars files in the correct order based on established patterns matching:
# - ${github_repo}/iac/env/${github_repo_tolder} is where terraform is executed from
# - ${github_repo_path} is always prefixed with iac and looks like iac/${github_repo_tolder}
# - ${github_repo}/iac/env/${github_repo_tolder} has a backend.tfvars file
# - ${github_repo}/iac/env/${github_repo_tolder} optionally has a variables.tfvars
#
function tfdo {
  local -r tf_do_current_dir="${PWD##*/}"
  local releative_path="../../../${PWD##*/}"
  local -r tf_do_action=$1
  local tf_do_var_file="variables.tfvars"
  local tf_do_cmd_switch="var-file"
  if [ "init" == "$1" ]; then
    #rm -rf .terraform
    tf_do_var_file="backend.tfvars"
    tf_do_cmd_switch="backend-config"
  fi
  local base_var_file_cmd="-$tf_do_cmd_switch=../$tf_do_var_file"
  local nested_var_file_cmd=""
  if [ -f "$tf_do_var_file" ]; then
    local nested_var_file_cmd="-$tf_do_cmd_switch=$tf_do_var_file"
    echo "tfdo - terraform $1 $base_var_file_cmd $nested_var_file_cmd $releative_path"
    terraform "$1" $base_var_file_cmd $nested_var_file_cmd $releative_path
  else
    echo "tfdo - terraform $1 $base_var_file_cmd $releative_path"
    terraform "$1" $base_var_file_cmd $releative_path
  fi
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

function manpdf() {
 man -t "${1}" | open -f -a /Applications/Preview.app/
}

#https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
PS1="\D{%Y.%m.%d-%H:%M:%S}|\w:"
export EDITOR=vim
export PATH="/usr/local/opt/libressl/bin:/usr/local/opt/curl/bin:$PATH"

# this alias is for self-generated ssh keys that have been imported into AWS.
# alias awsimportedkeyfp='for file in `ls ~/.ssh/*id_rsa$*`; do echo -n $file " - " ; openssl pkey -in $file -pubout -outform DER | openssl md5 -c; done'
# this alias is for AWS-generated ssh keys.
# alias awsgeneratedkeyfp='for file in `ls ~/.ssh/aws_gen_*`; do echo -n $file " - " ; openssl pkcs8 -in $file -nocrypt -topk8 -outform DER | openssl sha1 -c ; done'

# Set go on the path if go is installed.
if [ ! "" == "$(which go)" ]; then
  export PATH=$PATH:$(go env GOPATH)/bin
  export GOPATH=$(go env GOPATH)
fi

#For bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
