FROM debian:trixie

RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./tools/my.cnf /etc/mysql/my.cnf
COPY ./tools/entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 3306