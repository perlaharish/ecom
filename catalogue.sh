echo -e "#########copy the repo files #########"
cp catalogue.service /etc/systemd/system/catalogue.service &>> /tmp/catalogue.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> /tmp/catalogue.log
echo -e "#########Reload daemon service #########"
systemctl daemon-reload  &>> /tmp/catalogue.log
dnf module disable nodejs -y &>> /tmp/catalogue.log
dnf module enable nodejs:18 -y &>> /tmp/catalogue.log
echo -e "#########Install nodejs #########"
dnf install nodejs -y &>> /tmp/catalogue.log
echo -e "#########user add #########"
useradd roboshop &>> /tmp/catalogue.log
echo -e "#########copy the code files #########"
rm -rf /app &>> /tmp/catalogue.log
mkdir /app &>> /tmp/catalogue.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>> /tmp/catalogue.log
cd /app &>> /tmp/catalogue.log
echo -e "#########unzip the repo files #########"
unzip /tmp/catalogue.zip &>> /tmp/catalogue.log
echo -e "#########Install app dependent files #########"

npm install &>> /tmp/catalogue.log
echo -e "#########Restart catalogue service #########"
systemctl enable catalogue &>> /tmp/catalogue.log
systemctl restart catalogue &>> /tmp/catalogue.log
echo -e "#########Install mongo shell #########"

dnf install mongodb-org-shell -y &>> /tmp/catalogue.log
echo -e "#########schema load to mongo db #########"
mongo --host 172.31.42.57 </app/schema/catalogue.js &>> /tmp/catalogue.log

