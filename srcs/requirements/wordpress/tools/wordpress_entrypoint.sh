#!/bin/bash

wp core download --allow-root

# Docker Secrets 파일 읽기
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_USER=$(cat /run/secrets/wp_admin_user)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_ADMIN_EMAIL=$(cat /run/secrets/wp_admin_email)

DOMAIN_NAME=${DOMAIN_NAME:-"jaehukim.42.fr"}
WP_TITLE=${WP_TITLE:-"My WordPress Site"}

# 간단한 대기 (MariaDB 시작 시간 고려)
echo "Waiting for MariaDB to be ready..."
sleep 30

# WP-CLI로 wp-config.php 생성
wp config create \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="mariadb:3306" \
    --allow-root

# WordPress 설치
wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

php-fpm8.4 --nodaemonize