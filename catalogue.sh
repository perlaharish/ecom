echo -e "#########copy the repo files #########"
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "#########Reload daemon service #########"
systemctl daemon-reload
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
echo -e "#########Install nodejs #########"
dnf install nodejs -y
echo -e "#########user add #########"
useradd roboshop
echo -e "#########copy the code files #########"
rm -rf /app
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "#########unzip the repo files #########"
unzip /tmp/catalogue.zip
echo -e "#########Install app dependent files #########"

npm install
echo -e "#########Restart catalogue service #########"
systemctl enable catalogue
systemctl restart catalogue
echo -e "#########Install mongo shell #########"

dnf install mongodb-org-shell -y
echo -e "#########schema load to mongo db #########"
mongo --host 172.31.42.57 </app/schema/catalogue.js

