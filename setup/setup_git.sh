#!/usr/bin/env bash
#
# Created By: Stephan Sarver
# Created Date: 2017.08.16.11.28.27
#

user_name=''
user_id=''
user_email=''
home_dir="/Users/$user_name"

git config --global user.name "$user_name"
git config --global user.email "$user_email"
git config --global core.editor vim

git config --list

#echo "Set up the 2 factor template file for githiub:"
#echo "machine github.allstate.com"> $home_dir/.netrc
#echo "login $user_name">> $home_dir/.netrc
#echo "password REPLACE_ME">> $home_dir/.netrc
#echo "protocol https">> $home_dir/.netrc
