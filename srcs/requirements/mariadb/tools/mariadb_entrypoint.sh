#! /bin/bash

service mysql start

TMP_SQL="/tmp/init.sql"
touch $TMP_SQL
chmod 600 $TMP_SQL

# Docker Secrets 파일 읽기 (/run/secrets/에서 들고오기)
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# MariaDB 초기화
echo "CREATE DATABASE IF NOT EXISTS $DB_NAME ;" > $TMP_SQL
echo "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD' ;" >> $TMP_SQL
echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' ;" >> $TMP_SQL
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD' ;" >> $TMP_SQL
echo "FLUSH PRIVILEGES;" >> $TMP_SQL

mysql < $TMP_SQL
rm $TMP_SQL

service mysql stop
mysqld_safe --user=mysql