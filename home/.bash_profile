#Note this file needs to be set based on the cloned location of the repo.
REPOS_BASE_DIR="/Users/$(whoami)/Documents/repos"

MAC_SETTINGS_HOME="$REPOS_BASE_DIR/mac_settings/home"
MAC_SETTINGS_SETUP="$REPOS_BASE_DIR/mac_settings/setup"

UTILITY_SCRIPTS_GITDIR_FILE="$REPOS_BASE_DIR/utility_scripts/gitdir"
ONELOGIN_CREDS_LOCATION="$REPOS_BASE_DIR/onelogin-python-aws-assume-role/src/onelogin/aws-assume-role"

ONELOGIN_ODIN_CREDS_LOCATION="$REPOS_BASE_DIR/opploans/opploans-odin/odin-tools/onelogin"
ONELOGIN_ODIN_ASSUME_SCRIPT_NAME="onelogin-aws-assume-role.py"

# for file in "$(find $MAC_SETTINGS_HOME/.functions -type f -maxdepth 1 -name '*.*_functions' -print -quit)"; do
for file in $(find $MAC_SETTINGS_HOME/.functions -type f -name '*.*_functions'); do
  source "$file";
done

alias grepc="grep --color=auto"
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
alias cdop="cd $REPOS_BASE_DIR/opploans/opploans"

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
    export AWS_DEFAULT_REGION="$AWS_REGION"
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

function unsetaws {
  #https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_DEFAULT_REGION
  unset AWS_DEFAULT_OUTPUT
  unset AWS_DEFAULT_PROFILE
  unset AWS_CA_BUNDLE
  unset AWS_SHARED_CREDENTIALS_FILE
  unset AWS_CONFIG_FILE
  #https://docs.aws.amazon.com/cli/latest/topic/config-vars.html
  unset AWS_PROFILE
  unset AWS_METADATA_SERVICE_TIMEOUT
  unset AWS_METADATA_SERVICE_NUM_ATTEMPTS
  #I think this is remanant of usage thart was supposed to be looking at AWS_DEFAULT_REGION yet here it lives on :(
  unset AWS_REGION
}


alias unsetcreds="unset AWS_SHARED_CREDENTIALS_FILE"
alias checkcreds="printenv | grep AWS_SHARED_CREDENTIALS_FILE"
alias unsetprofile="unset AWS_PROFILE"
alias checkprofile="printenv | grep AWS_PROFILE"
alias checkaws="printenv | grep AWS_"
alias awswhoami="aws iam list-account-aliases | jq -r \".AccountAliases[0]\";aws sts get-caller-identity"

alias sshbastion="ssh -i ~/.ssh/id_rsa ubuntu@SOMEIPADDRESSS"
alias tfinitrm="rm -rf .terraform;unset AWS_SHARED_CREDENTIALS_FILE;rm awscreds*;rm *tfstate*"

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
  vim "$MAC_SETTINGS_HOME/.bash_profile"
}

# Copy mac settings project bash profile file into the users home directory
function cpbp {
  cp "$MAC_SETTINGS_HOME/.bash_profile" ~/.bash_profile
}

# Source the users bash profile file
function sourcebp {
  source ~/.bash_profile
}

function cpsbp {
  cp "$MAC_SETTINGS_HOME/.bash_profile" ~/.bash_profile
  source ~/.bash_profile
}


# Open mac_settings project install_tools.sh script for editing
function viit {
  vi "$MAC_SETTINGS_SETUP/install_tools.sh"
}

# Run the install_tools.sh script in the mac_settings project
function doit {
  bash -c "$MAC_SETTINGS_SETUP/install_tools.sh"
}

# Copy the gitdir.sh script to the current directory
function cpgitdir {
  cp $UTILITY_SCRIPTS_GITDIR_FILE gitdir
  chmod +x gitdir
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
  # local target="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$1*" --region "$AWS_REGION")"
  local target="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$1*")"
  local target_name="$(echo $target| jq -r '.Reservations[0].Instances[]|.Tags[]|select(.Key=="Name")|.Value')"
  target_id="$(echo $target| jq -r '.Reservations[0].Instances[]|.InstanceId')"
  echo "Connection to instance via ssm: [$target_name] - [$target_id]"
  # aws ssm start-session --target "$target_id" --region "$AWS_REGION"
  aws ssm start-session --target "$target_id"
}

function ssminventory {
  echo "============================================================"
  local sts_output=$(aws sts get-caller-identity | jq -r '.Arn')
  echo "Using AWS Credentials: $sts_output"
  echo " "
  echo "Show SSM Ec2 Instance Inventory:"
  echo " "
  local result_size="100"
  # local instance_ids=($(aws ssm get-inventory --max-items "$result_size" --page-size" $result_size" | jq -r '.Entities[] | .Data | ."AWS:InstanceInformation" | .Content[] | select(.InstanceStatus!="Terminated") | .InstanceId'))
  local instance_ids=($(aws ssm get-inventory | jq -r '.Entities[] | .Data | ."AWS:InstanceInformation" | .Content[] | select(.InstanceStatus!="Terminated") | .InstanceId'))
  # NOTE: Here we want to use the pagination api and build the full list before moving on to gettign the ec2 information

  local instance_ids_spaced_list=''
  for id in ${instance_ids[@]}
  do
    instance_ids_spaced_list="$instance_ids_spaced_list${id} "
  done
  local describe_output="$(aws ec2 describe-instances --instance-ids $instance_ids_spaced_list)"
  echo "$describe_output" | jq -r '.Reservations[] | .Instances[] | .Tags[] | select(.Key=="Name") | .Value'
  echo "============================================================"
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
