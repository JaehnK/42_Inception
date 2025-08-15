#!/bin/ash

# Docker secrets에서 비밀번호 읽기
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_USER=$(cat /run/secrets/db_user 2>/dev/null || echo "default_user")
# 데이터 디렉토리 확인
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    # MariaDB 초기화 (처음 실행시에만)
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # MariaDB 임시 시작 (설정을 위해)
    mysqld_safe --datadir=/var/lib/mysql --user=mysql --skip-networking &
    
    # MariaDB가 시작될 때까지 대기
    while ! mysqladmin ping --silent; do
        sleep 1
    done
    
    echo "Setting up database and users..."
    # 사용자 및 데이터베이스 설정 (초기화시에만)
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"
    
    # 임시 프로세스 종료
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
fi

echo "Starting MariaDB..."
# 포그라운드로 실행
exec mysqld_safe --datadir=/var/lib/mysql --user=mysql
