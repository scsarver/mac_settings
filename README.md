# mac_settings

When starting a brand new setup (Written for MacOSX Monterey 12.3.1) it is useful to set some standards to keep things organized.
- Use the Documents folder with a repos directory containing a directory for each organization you are checking code out from.
  - Run mkdir -p ~/Documents/repos/scsarver
  - cd ~/Documents/repos/scsarver
- Ensure git is installed
  - The system will prompt you because 'git requires the command line developer tools' to be installed. (click install and accept the license agreement)
- Checkout this project scsarver/mac_settings
- Navigate to the scsarver/mac_settings/home directory
- Copy the .bash_profile to your home directory and source the file in your terminal.
- Copy the .vimrc to your home directory.
- Navigate to the scsarver/mac_settings/setup directory
- Ensure Homebrew is installed
  - See: https://brew.sh
  - NOTE: The setup script does attempt to install brew if it is not installed but what is in that script block shows an example of issues encountered on a system with shared users and directory ownership problems. Do teh default install as outlined on the website and then run brew doctor.
- run the install_tools.sh script.


Post install script needs:
- run docker to accept the terms and conditions then signin with your id



Remember:
- Script everything as a record of what was installed.
- Use Homebrew
- For commonly used tools create a functions file including helper functions and aliases, dont forget to add a help function.