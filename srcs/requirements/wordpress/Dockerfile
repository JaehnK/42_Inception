FROM debian:trixie

RUN apt-get update -y && apt-get install -y \
    php-fpm \
    php-mysql \
    php-json \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    php-zip \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/wp-config.php /

COPY ./tools/wordpress_entrypoint.sh /wordpress_entrypoint.sh
RUN chmod +x /wordpress_entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000
ENTRYPOINT ["/wordpress_entrypoint.sh"]