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

curl -sSL "$REPO/c.sh" -o c.sh
curl -sSL "$REPO/devices_c.txt" -o devices_c.txt

chmod +x c.sh

# 🛠️ Adding an alias for easy launch 
if ! grep -q "alias c=" ~/.bashrc; then
    echo "alias c='bash ~/c.sh'" >> ~/.bashrc
    echo -e "\e[32m✅ Alias 'c' has been added.\e[0m"
fi
source ~/.bashrc
clear
exit
