FROM debian:trixie

RUN apt-get update -y && apt-get install -y \
    php8.4-fpm \
    php8.4-mysql \
    php8.4-curl \
    php8.4-gd \
    php8.4-xml \
    php8.4-mbstring \
    php8.4-zip \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/www.conf /etc/php/8.4/fpm/pool.d/www.conf

COPY ./tools/wordpress_entrypoint.sh /wordpress_entrypoint.sh
RUN chmod +x /wordpress_entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000
ENTRYPOINT ["/wordpress_entrypoint.sh"]