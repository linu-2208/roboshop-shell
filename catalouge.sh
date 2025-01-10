#!/bin/bash

Id=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
MONGODB_HOST=mongodb.myver.shop


TIMESTAMP=$(date +%F-%H-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE


VALIDATE(){
     if [ $1 -ne 0 ]
     then
         echo -e "$2...$R FAiled $N"
     else
        echo -e "$2... $G SUCESS $N"
     fi       

}

if [ $Id -ne 0 ]
then
   echo -e " $R Error: Please run this script as root user $N"
   exit 1
else 
    echo "You are root user"
 fi   

 dnf module disable nodejs -y &>> $LOGFILE

 VALIDATE $? "Diasabling current nodejs" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling  nodejs 18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop &>> $LOGFILE

VALIDATE $? "creating roboshop user"

mkdir /app &>> $LOGFILE

VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "downloading catalouge app "

cd /app &>> $LOGFILE

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "unzipping catalouge app"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

#use absolute path ,because catalouge.service existing
cp /home/centos/roboshop-shell/catalouge.service /etc/systemd/system/catalogue.service

VALIDATE $? "copying catalouge services"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Demon reloading"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling catalouge services"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catalouge services"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalouge data into mongo db"







