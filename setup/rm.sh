#!/usr/bin/env bash

sudo rm -r /usr/local/Homebrew

sudo rm -r /usr/local/Cellar
sudo rm -r /usr/local/Frameworks
sudo rm -r /usr/local/etc
sudo rm -r /usr/local/include
sudo rm -r /usr/local/lib
sudo rm -r /usr/local/opt
sudo rm -r /usr/local/sbin
sudo rm -r /usr/local/share
sudo rm -r /usr/local/var


sudo rm /usr/local/bin/brew

sudo rm /usr/local/bin/jq
sudo rm /usr/local/bin/onig-config



echo "---Show /usr/local -----"
ls -la /usr/local

echo "---Show /usr/local/bin -----"
ls -la /usr/local/bin