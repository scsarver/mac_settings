#Note this file needs to be set based on the cloned location of the repo.
REPOS_BASE_DIR="/Users/$(whoami)/Documents/repos"

MAC_SETTINGS_HOME="$REPOS_BASE_DIR/scsarver/mac_settings/home"
MAC_SETTINGS_SETUP="$REPOS_BASE_DIR/scsarver/mac_settings/setup"

UTILITY_SCRIPTS_GITDIR_FILE="$REPOS_BASE_DIR/scsarver/utility_scripts/gitdir"

OPENDNS_1="208.67.222.222"
OPENDNS_2="208.67.220.220"
CLOUDFLAREDNS_1="1.1.1.1"
CLOUDFLAREDNS_2="1.0.0.1"
GOOGLE_DNS_1="8.8.8.8"
GOOGLE_DNS_2="8.8.4.4"

PING_TARGET="$CLOUDFLAREDNS_1"
alias pingone="ping -c 1 $PING_TARGET"
alias pingfour="ping -c 4 $PING_TARGET"
alias pingten="ping -c 10 $PING_TARGET"

function resolvedns {
  curl https://dns.google.com/resolve?name=$1
}

# for file in "$(find $MAC_SETTINGS_HOME/.functions -type f -maxdepth 1 -name '*.*_functions' -print -quit)"; do
for file in $(find $MAC_SETTINGS_HOME/.functions -type f -name '*.*_functions'); do
  source "$file";
done

# NOTE: To see the declared functions from the terminal run the command: declare -F
# NOTE: To see the declared aliases from the terminal run the command: alias

alias atomcfg="vim /Users/$(whoami)/.atom/config.cson"

alias grepc="grep --color=auto"
alias ll="ls -la"
alias untar='tar -zxvf '
alias speed='speedtest-cli --server 2406 --simple'
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipe='curl ipinfo.io/ip'
alias ipi='ipconfig getifaddr en0'
alias getweather="curl -4 http://wttr.in/chicago"


alias sshbastion="ssh -i ~/.ssh/id_rsa ubuntu@SOMEIPADDRESSS"

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

function vifunction {
  if [ "" == "$1" ]; then
    echo "functions file type required!"
  fi
  if [ -f "$MAC_SETTINGS_HOME/.functions/$(ls -a $MAC_SETTINGS_HOME/.functions | grep $1_functions)" ]; then
    vim "$MAC_SETTINGS_HOME/.functions/$(ls -a $MAC_SETTINGS_HOME/.functions | grep $1_functions)"
  else
    echo "Function file not found: $MAC_SETTINGS_HOME/.functions/$(ls -a $MAC_SETTINGS_HOME/.functions | grep $1_functions)"
  fi
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

function getoathtkn {
  if [ -f "$1" ]; then
    oathtool --base32 --totp "$(zbarimg -q $1 | sed 's/.*secret=//' | sed 's/&.*//')"
  else
    echo "Expected file input was not found: $1"
  fi
}

#https://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
# PS1="\033[2m\D{%Y.%m.%d-%H:%M:%S}\033[0m\033[1m|\033[0m\w\033[1m:\033[0m"
# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux/20983251#20983251
# Added exscaping for PS1 using ansi codes see above link.
PS1="\[\033[2m\]\D{%Y.%m.%d-%H:%M:%S}\[\033[0m\]\[\033[1m\]|\[\033[0m\]\w\[\033[1m\]:\[\033[0m\]"
export EDITOR=vim
# NOTE: Added /usr/local/sbin as suggetsed by brew doctor
# export PATH="/usr/local/opt/libressl/bin:/usr/local/opt/curl/bin:/usr/local/sbin:$PATH"

# NOTE: Added this oddball location for fly/concourse: /Users/sarvers/Documents/repos/scsarver/utility_scripts/concourse/fly
export PATH="/Users/sarvers/Documents/repos/scsarver/utility_scripts/concourse:/usr/local/opt/libressl/bin:/usr/local/opt/curl/bin:/usr/local/sbin:$PATH"

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
