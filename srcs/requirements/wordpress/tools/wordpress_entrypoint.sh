#!/bin/bash

echo "Waiting for MariaDB to be ready..."
sleep 10

# Docker Secrets 파일 읽기
DB_NAME=$(cat /run/secrets/db_name)
DB_USER=$(cat /run/secrets/db_user)
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_USER=$(cat /run/secrets/wp_admin_user)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_ADMIN_EMAIL=$(cat /run/secrets/wp_admin_email)

# 환경변수 기본값 설정
DOMAIN_NAME=${DOMAIN_NAME:-"jaehukim.42.fr"}
WP_TITLE=${WP_TITLE:-"My WordPress Site"}

# WordPress Core 다운로드 (아직 없는 경우)
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Downloading WordPress core..."
    wp core download --allow-root
fi

# WordPress 설치 및 설정
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root \
        --skip-check

    echo "Installing WordPress..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    # # 추가 사용자 생성
    # if [ -n "$WP_USER_LOGIN" ] && [ -n "$WP_USER_EMAIL" ] && [ -n "$WP_USER_PASSWORD" ]; then
    #     echo "Creating additional user..."
    #     wp user create "$WP_USER_LOGIN" "$WP_USER_EMAIL" \
    #         --role=author \
    #         --user_pass="$WP_USER_PASSWORD" \
    #         --allow-root
    # fi

    # WordPress 설정
    echo "Configuring WordPress settings..."
    wp config set FORCE_SSL_ADMIN 'false' --allow-root

    # # Redis 캐시 설정
    # if [ -n "$REDIS_HOST" ]; then
    #     echo "Setting up Redis cache..."
    #     wp config set WP_REDIS_HOST "$REDIS_HOST" --allow-root
    #     wp config set WP_REDIS_PORT "${REDIS_PORT:-6379}" --allow-root
    #     wp config set WP_CACHE 'true' --allow-root
        
    #     wp plugin install redis-cache --allow-root
    #     wp plugin activate redis-cache --allow-root
    #     wp redis enable --allow-root
    # fi

    # 파일 권한 설정
    echo "Setting up file permissions..."
    chmod 755 /var/www/html/wp-content
    chown -R www-data:www-data /var/www/html/wp-content

    # 테마 설치 및 활성화
    echo "Installing and activating theme..."
    wp theme install twentyfifteen --allow-root
    wp theme activate twentyfifteen --allow-root
    wp theme update twentyfifteen --allow-root

    echo "WordPress installation completed!"
else
    echo "WordPress is already installed."
fi

echo "Starting PHP-FPM..."
php-fpm8.4 --nodaemonize