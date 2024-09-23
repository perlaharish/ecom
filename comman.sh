func_nodejs(){
log=/tmp/roboshop.log
echo -e "\e[32m#########copy the repo files #########\e[0m" | tee -a >> ${log}
cp ${component}.service /etc/systemd/system/${component}.service &>> ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> ${log}
echo -e "\e[32m#########Reload daemon service #########\e[0m" | tee -a >> ${log}
systemctl daemon-reload  &>> ${log}
dnf module disable nodejs -y &>> ${log}
dnf module enable nodejs:18 -y &>> ${log}
echo -e "\e[32m#########Install nodejs #########\e[0m" | tee -a >> ${log}
dnf install nodejs -y &>> ${log}
echo -e "\e[32m#########user add #########\e[0m" | tee -a >> ${log}
useradd roboshop &>> ${log}
echo -e "\e[32m#########copy the code files #########\e[0m" | tee -a >> ${log}
rm -rf /app &>> ${log}
mkdir /app &>> ${log}
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log}
cd /app &>> ${log}
echo -e "\e[32m#########unzip the repo files #########\e[0m" | tee -a >> ${log}
unzip /tmp/${component}.zip &>> ${log}
echo -e "\e[32m#########Install app dependent files #########\e[0m" | tee -a >> ${log}

npm install &>> ${log}
echo -e "\e[32m#########Restart ${component} service #########\e[0m" | tee -a >> ${log}
systemctl enable ${component} &>> ${log}
systemctl restart ${component} &>> ${log}
echo -e "\e[32m#########Install mongo shell #########\e[0m" | tee -a >> ${log}

dnf install mongodb-org-shell -y &>> ${log}
echo -e "\e[32m#########schema load to mongo db #########\e[0m" | tee -a >> ${log}
mongo --host 172.31.42.57 </app/schema/${component}.js &>> ${log}
}