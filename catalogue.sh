cp catalogue.service /etc/systemd/system/catalogue.service
cp mongodb-org-7.0.repo /etc/yum.repos.d/mongodb-org-7.0.repo
systemctl daemon-reload
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
useradd roboshop
rm -rf /app
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

npm install
systemctl enable catalogue
systemctl restart catalogue

sudo dnf install -y mongodb-mongosh
sudo dnf sudo install -y mongodb-mongosh-shared-openssl11
sudo dnf install -y mongodb-mongosh-shared-openssl3
mongo --host 3.87.207.41 </app/schema/catalogue.js

