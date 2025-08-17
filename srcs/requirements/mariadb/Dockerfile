FROM debian:trixie

RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/mariadb_entrypoint.sh /

RUN chmod +x /mariadb_entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/mariadb_entrypoint.sh"]
