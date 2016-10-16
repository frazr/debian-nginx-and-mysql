FROM debian:latest

# Install packages
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get -y install \
  pwgen \
  supervisor \
  git \
  nginx \
  mysql-server

# Add persistance volume 
VOLUME  ["/data"]

ADD scripts/* /root/scripts/
ADD rootfs /

RUN mkdir /var/run/mysql && \
    touch /var/run/mysql/mysqld.pid && \
    chown -R mysql. /var/run/mysql && \
    chmod 766 /var/run/mysql/mysqld.pid

EXPOSE 80 3306
CMD ["/root/scripts/run.sh"]
