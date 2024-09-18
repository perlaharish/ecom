echo -e "#########copy the repo files #########" | tee -e &>> /tmp/catalogue.log
cp catalogue.service /etc/systemd/system/catalogue.service &>> /tmp/catalogue.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> /tmp/catalogue.log
echo -e "#########Reload daemon service #########" | tee -e &>> /tmp/catalogue.log
systemctl daemon-reload  &>> /tmp/catalogue.log
dnf module disable nodejs -y &>> /tmp/catalogue.log
dnf module enable nodejs:18 -y &>> /tmp/catalogue.log
echo -e "#########Install nodejs #########" | tee -a >> /tmp/catalogue.log
dnf install nodejs -y &>> /tmp/catalogue.log
echo -e "#########user add #########" | tee -a >> /tmp/catalogue.log
useradd roboshop &>> /tmp/catalogue.log
echo -e "#########copy the code files #########" | tee -e &>> /tmp/catalogue.log
rm -rf /app &>> /tmp/catalogue.log
mkdir /app &>> /tmp/catalogue.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>> /tmp/catalogue.log
cd /app &>> /tmp/catalogue.log
echo -e "#########unzip the repo files #########" | tee -e &>> /tmp/catalogue.log
unzip /tmp/catalogue.zip &>> /tmp/catalogue.log
echo -e "#########Install app dependent files #########" | tee -e &>> /tmp/catalogue.log

npm install &>> /tmp/catalogue.log
echo -e "#########Restart catalogue service #########" | tee -e &>> /tmp/catalogue.log
systemctl enable catalogue &>> /tmp/catalogue.log
systemctl restart catalogue &>> /tmp/catalogue.log
echo -e "#########Install mongo shell #########" | tee -e &>> /tmp/catalogue.log

dnf install mongodb-org-shell -y &>> /tmp/catalogue.log
echo -e "#########schema load to mongo db #########" | tee -e &>> /tmp/catalogue.log
mongo --host 172.31.42.57 </app/schema/catalogue.js &>> /tmp/catalogue.log

