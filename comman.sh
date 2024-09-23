func_prereq(){
echo -e "\e[32m#########user add #########\e[0m" 
useradd roboshop &>> ${log}
echo -e "\e[32m#########copy the code files #########\e[0m"
rm -rf /app &>> ${log}
mkdir /app &>> ${log}
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log}
cd /app &>> ${log}
echo -e "\e[32m#########unzip the repo files #########\e[0m"
unzip /tmp/${component}.zip &>> ${log}
}

func_servicerestart(){
  echo -e "\e[32m#########Restart ${component} service #########\e[0m"  
  systemctl enable ${component} &>> ${log}
  systemctl restart ${component} &>> ${log}
}

func_nodejs(){
log=/tmp/roboshop.log
echo -e "\e[32m#########copy the service files####[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>> ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> ${log}
echo -e "\e[32m#########Reload daemon service #########\e[0m"  
systemctl daemon-reload  &>> ${log}
dnf module disable nodejs -y &>> ${log}
dnf module enable nodejs:18 -y &>> ${log}
echo -e "\e[32m#########Install nodejs #########\e[0m"  
dnf install nodejs -y &>> ${log}
func_prereq
echo -e "\e[32m#########Install app dependent files #########\e[0m"
npm install &>> ${log}

func_servicerestart

echo -e "\e[32m#########Install mongo shell #########\e[0m"  
dnf install mongodb-org-shell -y &>> ${log}
echo -e "\e[32m#########schema load to mongo db #########\e[0m"  
mongo --host 172.31.42.57 </app/schema/${component}.js &>> ${log}
}

func_python(){
  echo -e "\e[32m#########copy service file #########\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service
  echo -e "\e[32m#########reload daemon service #########\e[0m"
  systemctl daemon-reload
  echo -e "\e[32m#########Install python #########\e[0m"
  dnf install python36 gcc python3-devel -y
  echo -e "\e[32m#########copy code files and unzip#########\e[0m"
  func_prereq
  echo -e "\e[32m#########Install python dependencies #########\e[0m"
  pip3.6 install -r requirements.txt
  echo -e "\e[32m#########Restart services #########\e[0m"
  func_servicerestart
}

func_java(){
  echo -e "\e[32m#########copy daemon files #########\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service
  echo -e "\e[32m#########reload daemon service #########\e[0m"
  systemctl daemon-reload
  echo -e "\e[32m#########Install maven #########\e[0m"
  dnf install maven -y
  echo -e "\e[32m#########copy code and unzip #########\e[0m"
  func_prereq
  echo -e "\e[32m########build maven package #########\e[0m"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar
   echo -e "\e[32m#########Install mysql and load schema #########\e[0m"
  dnf install mysql -y
  mysql -h 172.31.47.181 -uroot -pRoboShop@1 < /app/schema/${component}.sql
    echo -e "\e[32m#########restart service #########\e[0m"
     func_servicerestart
}