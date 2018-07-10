#!/usr/bin/env bash
#
# Created By: Stephan Sarver
# Created Date: 2017.08.10
#
# This script is used to check for installed software and install it if it is not found.
#
#

homebrew_packages=(
  'packer'
  'terraform'
  'awscli'
  'git'
  'tree'
  'python3'
  'jq'
  'wireshark'
  'golang'
  'glide'
  'groovy'
  'python'
  'bash-completion'
)

homebrew_casks=(
  'google-chrome'
  'atom'
  'virtualbox'
  'vagrant'
  'slack'
  'iterm2'
  'sublime-text'
  'wireshark'
  'java'
  'meld'
  'spotify'
  'docker'
)

homebrew_taps=(
  'homebrew/boneyard'
)

python2_pips=(
  'boto'
  'boto3'
  'requests-ntlm'
  'bs4'
  'pytz'
  'configparser'
  'python-dateutil'
  'awsume'
  'simplejson'
  #'urllib'
  #'urllib2'
  'urllib3'
  'demjson'
  'yamllint'
  'ruamel.yaml'
)

python3_pips=(
  'boto'
  'boto3'
  'requests-ntlm'
  'bs4'
  'pytz'
  'configparser'
  'python-dateutil'
  'awsume'
  'simplejson'
  #'urllib'
  #'urllib2'
  'urllib3'
  'demjson'
  'yamllint'
  'ruamel.yaml'
)

set +e
clear
echo "Checking for software installations and installing if they are not found."
echo "Checking for the xcode version $(/usr/bin/xcodebuild -version)"

echo " "
echo "Checking ruby version: $(/usr/bin/ruby --version)"

#Skipping the package and cask install section while testing!!!
if true; then


#echo "Setting finder to show hidden files!"
#defaults write com.apple.finder AppleShowAllFiles TRUE
if [ "YES" != "$(defaults read com.apple.finder AppleShowAllFiles)" ]; then
  defaults write com.apple.finder AppleShowAllFiles YES
  killall Finder
fi

#echo "Setting finder to show paths in titlebar!"
#defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
if [ "YES" != "$(defaults read com.apple.finder _FXShowPosixPathInTitle)" ]; then
  defaults write com.apple.finder _FXShowPosixPathInTitle YES
  killall Finder
fi

echo "Check if Homebrew is installed!"
installed_homebrew="$(brew 2>&1 | tr -d '\r' | awk -F':' '{print $4}')"
#echo "output: X${installed_homebrew## }"
if [[ "${installed_homebrew## }" == "command not found" ]]; then
  echo "Homebrew is not installed..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew is installed!"
fi


echo "Need to set the PATH!!!!"
#Warning: Homebrew's sbin was not found in your PATH but you have installed
#formulae that put executables in /usr/local/sbin.
#Consider setting the PATH for example like so
#  echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile

echo " "
echo "Installing brew taps..."
for tap in "${homebrew_taps[@]}"
do
  echo "Installing tap: $tap"
  brew tap "$tap"
done

echo " "
echo "Installing brew packages..."
for package in "${homebrew_packages[@]}"
do
  echo "Installing package: $package"
  brew install "$package"
done

echo " "
echo "Installing brew casks..."
for cask in "${homebrew_casks[@]}"
do
  echo "Installing Cask: $cask"
  brew cask install "$cask"
done

#Need to fix owner on directories
#sudo chown ssasq /usr/local/share
#sudo chown ssasq /usr/local/share/zsh
#Need to unlink and relink kegs
#brew list -1 | while read line; do brew unlink $line; brew link --force $line; done

#echo " "
#echo "Installing python2 pips..."
#for pip in "${python2_pips[@]}"
#do
#  echo "Installing pip2: $pip"
#  pip2 install "$pip"
#done

#echo " "
#echo "Installing python3 pips..."
#for pip in "${python3_pips[@]}"
#do
#  echo "Installing pip3: $pip"
#  pip3 install "$pip"
#done

#echo " "
#echo "Checking for aws crednetials file: /Users/$(whoami)/.aws"
#if [[ ! -d "/Users/$(whoami)/.aws" ]]; then
#  echo "Make /Users/$(whoami)/.aws dir!"
#  mkdir "/Users/$(whoami)/.aws"
#fi
#if [[ ! -f "/Users/$(whoami)/.aws/credentials" ]]; then
#  echo "Make /Users/$(whoami)/.aws/ credentials!"
#  echo "[default]" > ~/.aws/credentials
#  echo "aws_access_key_id =" >> ~/.aws/credentials
#  echo "aws_secret_access_key =" >> ~/.aws/credentials
#fi

fi

#echo "NOTE: Terraform was removed from the brew installs as I could not find version 0.9.11"
#echo "  the following file was installed: https://releases.hashicorp.com/terraform/0.9.11/terraform_0.9.11_darwin_amd64.zip"
#echo "  it was extracted and moved to /usr/local/bin - mv ~/Downloads/terraform /usr/local/bin/terraform"
echo " "

echo "Completed!"
