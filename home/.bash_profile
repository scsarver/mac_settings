#Note this file needs to be set based on the cloned location of the repo.
REPOS_BASE_DIR="/Users/$(whoami)/Documents/repos"
MAC_SETTINGS_BP_FILE="$REPOS_BASE_DIR/mac_settings/home/.bash_profile"
MAC_SETTINGS_INSTALL_TOOLS_FILE="$REPOS_BASE_DIR/mac_settings/setup/install_tools.sh"
UTILITY_SCRIPTS_GITDIR_FILE="$REPOS_BASE_DIR/utility_scripts/gitdir.sh"
ONELOGIN_CREDS_LOCATION="$REPOS_BASE_DIR/onelogin-python-aws-assume-role/src/onelogin/aws-assume-role"

ONELOGIN_ODIN_CREDS_LOCATION="$REPOS_BASE_DIR/opploans/opploans-odin/odin-tools/onelogin"
ONELOGIN_ODIN_ASSUME_SCRIPT_NAME="onelogin-aws-assume-role.py"

alias ll="ls -la"
alias untar='tar -zxvf '
alias speed='speedtest-cli --server 2406 --simple'
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipe='curl ipinfo.io/ip'
alias ipi='ipconfig getifaddr en0'
alias getweather="curl -4 http://wttr.in/chicago"

alias gs='git status'
alias gb='git branch'
alias glo='git log --oneline'
alias gls='git log --stat'
alias glp="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias cdrepos="cd $REPOS_BASE_DIR"
alias cdodin="cd $REPOS_BASE_DIR/opploans/opploans-odin"
alias cdonelog="cd $ONELOGIN_CREDS_LOCATION"
alias cdproto="cd $REPOS_BASE_DIR/prototype"

alias awsacctalias="aws iam list-account-aliases | jq -r \".AccountAliases[0]\""
alias awsgetcaller="aws sts get-caller-identity"
alias awsoneloginconfig="vim $ONELOGIN_ODIN_CREDS_LOCATION/onelogin.sdk.json"

function awsonelogin {
    python "$ONELOGIN_ODIN_CREDS_LOCATION/$ONELOGIN_ODIN_ASSUME_SCRIPT_NAME"
}

function awsoneloginset {
    export AWS_SHARED_CREDENTIALS_FILE="$(cat $ONELOGIN_ODIN_CREDS_LOCATION/onelogin.sdk.json | jq -r '.aws_shared_credentials_file')"
    export AWS_PROFILE="$(cat $ONELOGIN_ODIN_CREDS_LOCATION/onelogin.sdk.json | jq -r '.aws_profile')"
    export AWS_REGION="$(cat $ONELOGIN_ODIN_CREDS_LOCATION/onelogin.sdk.json | jq -r '.aws_region')"
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
alias checkaws="printenv | grep AWS_"
alias awswhoami="aws iam list-account-aliases | jq -r \".AccountAliases[0]\";aws sts get-caller-identity"

alias sshbastion="ssh -i ~/.ssh/id_rsa ubuntu@SOMEIPADDRESSS"
alias tfinitrm="rm -rf .terraform;unset AWS_SHARED_CREDENTIALS_FILE;rm awscreds*;rm *tfstate*"

function tfdo_old {
  local -r tf_do_current_dir="${PWD##*/}"
  local -r tf_do_action=$1
  # local tf_do_var_file="terraform.tfvars"
  local tf_do_var_file="variables.tfvars"
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
  if [ "apply" == "$1" ] && [ "-aa" == "$2" ]; then
    local base_var_file_cmd="-auto-approve $base_var_file_cmd"
  fi
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

# Utility function to quickly shift between the base tolder and environment directories
function tfenv {
  if [ "" == "$1" ]; then
    echo "Environment parameter is missing!"
  else
    if [ -d "../env/$1" ] && [ -d "../env/$1/${PWD##*/}" ]; then
      cd "../env/$1/${PWD##*/}"
    else
      echo "The path: ../env/$1/${PWD##*/} does not exist!"
    fi
  fi
}

# Utility function to quickly shift between the base tolder and environment directories
function tfbase {
  if [ -d "../../../${PWD##*/}" ]; then
    cd "../../../${PWD##*/}"
  else
    echo "The path: ../env/iac/$1/${PWD##*/} does not exist!"
  fi
}

function tfunlock {
  REMOTE_STATE_DYNAMODB_TABLE=`cat ../backend.tfvars | grep dynamodb_table | awk -F' ' '{print$3}' | sed 's/\(.*\)"/\1/' | sed 's/^"//'`
  REMOTE_STATE_BUCKET=`cat ../backend.tfvars | grep bucket | awk -F' ' '{print$3}' | sed 's/\(.*\)"/\1/' | sed 's/^"//'`
  REMOTE_STATE_REGION=`cat ../backend.tfvars | grep region | awk -F' ' '{print$3}' | sed 's/\(.*\)"/\1/' | sed 's/^"//'`
  REMOTE_STATE_KEY=`cat backend.tfvars | grep key | awk -F' ' '{print$3}' | sed 's/\(.*\)"/\1/' | sed 's/^"//'`
  DYNAMODB_DELETE_LOCK_PAYLOAD="{\"LockID\": {\"S\": \"$REMOTE_STATE_BUCKET/$REMOTE_STATE_KEY\"}}"
  # echo "aws dynamodb get-item --table-name $REMOTE_STATE_DYNAMODB_TABLE --key $DYNAMODB_DELETE_LOCK_PAYLOAD --region $REMOTE_STATE_REGION"
  aws dynamodb delete-item --table-name "$REMOTE_STATE_DYNAMODB_TABLE" --key "$DYNAMODB_DELETE_LOCK_PAYLOAD" --region "$REMOTE_STATE_REGION"
}

# This does not seem to work as expected and am commenting out until I have time to dig into it deeper
# function tfimport {
#   local releative_path="../../../${PWD##*/}"
#   local tfimport_var_file="variables.tfvars"
#   local tfimport_cmd_switch="var-file"
#   local base_var_file_cmd="-$tfimport_cmd_switch=../$tfimport_var_file"
#   local base_cmd="terraform import $base_var_file_cmd -config=$releative_path"
#   # local base_cmd="terraform import $base_var_file_cmd"
#   if [ -f "$tfimport_var_file" ]; then
#     local nested_var_file_cmd="-$tfimport_cmd_switch=$tfimport_var_file"
#     base_cmd="terraform import $base_var_file_cmd $nested_var_file_cmd -config=$releative_path"
#     # base_cmd="terraform import $base_var_file_cmd $nested_var_file_cmd"
#   fi
#
#   # echo "-----$(pwd)"
#   # pushd $(pwd)
#   # echo "-----$releative_path"
#   # cd "$releative_path"
#   # echo "-----"
#   # ls
#   # echo "-----"
#   if [ -f "$1" ]; then
#     while IFS= read -r var
#     do
#       echo "-----"
#       echo "$base_cmd ${var%[|]*} ${var#*[|]}"
#       `$base_cmd "${var%[|]*}" "${var#*[|]}"`
#     done < "$1"
#   fi
#   # popd
# }

function cdiac {
    local CURRENT_START_PATH="$(pwd)"
    local CURRENT_PATH="${CURRENT_START_PATH##*[/]}"
    if [[ $CURRENT_START_PATH == *"iac"* ]]; then
      while [ "iac" != "$CURRENT_PATH" ]
      do
        cd ..
        CURRENT_PATH_TMP="$(pwd)"
        CURRENT_PATH="${CURRENT_PATH_TMP##*[/]}"
      done
    else
        echo "No iac directory in the current path: $CURRENT_START_PATH"
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

#Install SSM Manager plugin
# Reference: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
# curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
# unzip sessionmanager-bundle.zip
# sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
# #Output should match: "The Session Manager plugin is installed successfully. Use the AWS CLI to start a session."
# session-manager-plugin
function ssmto {
  local sts_output=$(aws sts get-caller-identity | jq -r '.Arn')
  echo "Using AWS Credentials: $sts_output"
  echo " "
  echo "Searching for instancewith '$1' in the name..."
  local target="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$1*" --region "$AWS_REGION")"
  local target_name="$(echo $target| jq -r '.Reservations[0].Instances[]|.Tags[]|select(.Key=="Name")|.Value')"
  target_id="$(echo $target| jq -r '.Reservations[0].Instances[]|.InstanceId')"
  echo "Connection to instance via ssm: [$target_name] - [$target_id]"
  aws ssm start-session --target "$target_id" --region "$AWS_REGION"
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
