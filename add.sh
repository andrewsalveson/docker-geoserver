#!/bin/bash
# Script to add a user to Linux system

# check if user is root
if [ $(id -u) -ne 0 ]; then
	echo "Only root may add a user to the system"
	exit 2
fi

username=$1
# check if username exists
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
  echo "$username exists"
  exit 1
fi

# check if there is a 2nd argument for a pass, enter otherwise
if [ -z ${2} ]; then
  read -s -p "Enter password : " password
else
  password=$2
fi
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -m -p $pass $username

# add user to sftponly group (see /etc/ssh/sshd_config for settings)
usermod -a -G sftponly $username

#chsh -s /sbin/login $username
homedir="/home/$username"
homeupload="$homedir/uploads"
uploaddir="/var/geoserver/userdata/$username"
chown root:root $homedir
mkdir -p $uploaddir
mkdir -p $homeupload
#ln -s $uploaddir $homeupload
mount --bind $uploaddir $homeupload
chown $username:$username $uploaddir
chown $username:$username $homeupload
./comm.sh add user $username
[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
