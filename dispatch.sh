cp dispatch.service /etc/systemd/system/dispatch.service
systemctl daemon-reload
dnf install golang -y
useradd roboshop
mkdir /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip
cd /app
go mod init dispatch
go get
go build
systemctl enable dispatch
systemctl restart dispatch

