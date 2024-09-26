echo -e "\e[32m#########Insatll Nginx #########\e[0m"
dnf install nginx -y
echo -e "\e[32m#########copy roboshop conf file#########\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[32m#########empaty app folder #########\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[32m#########Download app content #########\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
echo -e "\e[32m#########extract app content #########\e[0m"
unzip /tmp/frontend.zip
echo -e "\e[32m#########Restart nginx service #########\e[0m"
systemctl enable nginx
systemctl restart nginx