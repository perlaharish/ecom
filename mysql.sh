mysql_root_pass=$1
cp mysql.repo /etc/yum.repos.d/mysql.repo
if [ -z ${mysql_root_pass} ]; then
  echo "Imported password missing"
  exit
  fi
dnf module disable mysql -y
dnf install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld
mysql_secure_installation --set-root-pass ${mysql_root_pass}
