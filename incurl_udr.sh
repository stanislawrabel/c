#!/bin/bash
set -e

# 🛠 Automatický mód
export DEBIAN_FRONTEND=noninteractive
export TERM=xterm

set -e

echo "📦 Updating Termux and installing dependencies..."
yes "" | pkg update -y
yes "" | pkg upgrade -y
echo N | dpkg --configure -a

pkg install -y python python2 git tsu curl
pip install wheel
pip install pycryptodome
pip3 install --upgrade requests pycryptodome git+https://github.com/R0rt1z2/realme-ota

echo "📥 Downloading scripts and data files..."
REPO="https://raw.githubusercontent.com/stanislawrabel/c/main"

curl -sSL "$REPO/udr.sh" -o udr.sh

chmod +x udr.sh

# 🛠️ Adding an alias for easy launch 
if ! grep -q "alias udr=" ~/.bashrc; then
    echo "alias urr='bash ~/udr.sh'" >> ~/.bashrc
    echo -e "\e[32m✅ Alias 'udr' has been added.\e[0m"
fi
source ~/.bashrc
clear
exit
