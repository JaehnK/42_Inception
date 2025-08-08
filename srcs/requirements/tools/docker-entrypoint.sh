#!/bin/bash

# Docker secrets에서 비밀번호 읽기
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_USER=$(cat /run/secrets/db_user 2>/dev/null || echo "default_user")

# MariaDB 초기화
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# MariaDB 시작
mysqld_safe --datadir=/var/lib/mysql --user=mysql &

# MariaDB가 시작될 때까지 대기
while ! mysqladmin ping --silent; do
    sleep 1
done

# 사용자 및 데이터베스 설정 (secrets 사용)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO '${MYSQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# 포그라운드로 실행
exec mysqld_safe --datadir=/var/lib/mysql --user=mysql
