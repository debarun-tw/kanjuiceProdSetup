#!/bin/bash
 DISTRO=$(uname | xargs)

command_exists () {
    type "$1" &> /dev/null ;
}

yum_install() {
  sudo yum install -y $1
}

validate_git() {
  if ! command_exists 'git'; then
    echo git is not installed, we will install it using brew now...
    yum_install 'git'
  fi
}

validate_mongodb() {
  if ! command_exists 'mongod'; then
    echo mongodb is not installed, we will install it using brew now...
    yum_install 'mongodb'
  fi
}

install_node() {
  echo We will install node...
  if [ "$(whoami)" != "root" ]
  then
    sudo su -s "$0"
    curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
    yum_install 'nodejs'
    exit
  fi
}

validate_wget() {
  if ! command_exists 'wget'; then
    echo wget is not installed, we will install it using brew now...
    yum_install 'wget'
  fi
}

install_kanjuice_repo() {
  echo We will install Kanjuice repo...
  git clone https://github.com/tw-blr-iot-ants/adjuvant.git
  cd adjuvant
  npm i
}

start_mongodb_server() {
  echo We will start mongodb server...
  sudo mkdir -p /data/db
  sudo chmod 777 /data/db
  mongod &
}

start_node_server() {
  echo We will start prod server...
  pkill -f "node server.js"
  npm install
  npm start &
}
