#!/bin/bash
datenow=`date +"%Y%m%d"`;
USER=""
PASSWORD=""
path="/root/mongodb_backup/$datenow"
DELPATH="/root/mongodb_backup/"
STATUS="/root/mongodb_backup/statusfile.$datenow"

# if the directory does not exist, make it please
if [ ! -d $path ]; then
  mkdir -p $path
else
 :
fi

errorcounter=0 #innitializing a variable to count errors in mongodump

printf "Dumping databases: \n"
mongodump --host localhost --port 27017 --username $USER --password "$PASSWORD" --archive=$path/`date +%Y%m%d`.gzip --gzip
exitcode=$?

FILESIZE=$(stat -c%s "$path/`date +%Y%m%d`.gzip")
printf "Backed up with EXITCODE [ $exitcode ] and with size $FILESIZE bytes\n";

#create an if to notify us in case of bad mysqldump
if [ $exitcode -ne 0 ]; then
  printf "\n\n ERROR BACKING UP === errorcode = $exitcode \n\n" >> $STATUS
  ((errorcounter++))
else
  printf "\nBacked up with EXITCODE [ $exitcode ] and with size $FILESIZE bytes\n" >> $STATUS
fi


#method to remove old database backups
if [ $errorcounter -ne 0 ]; then
  printf "Not deleting anything due to errors in mongodump\n" >> $STATUS
else
  find $DELPATH* -mtime +15 -exec rm {} \;
  printf "\nFiles older than 15 days have been deleted\n" >> $STATUS
fi