uploadhome="/home/$1/uploads"
uploads="/var/geoserver/userdata/$1"
umount $uploadhome
rm -rf $uploads
deluser --remove-home $1
./comm.sh del user $1
