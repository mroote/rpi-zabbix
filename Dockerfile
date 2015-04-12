# Pull base image 
FROM resin/rpi-raspbian:jessie
MAINTAINER Mitch Roote <mitch@r00t.ca>

# Install dependencies
RUN apt-get -y update 

RUN apt-get install -y locales dialog
RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure -f noninteractive locales

RUN echo mysql-server mysql-server/root_password select zabbix123 | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again select zabbix123 | debconf-set-selections
RUN apt-get install -yV \
    mysql-server \
    zabbix-server-mysql \
    zabbix-frontend-php \
    zabbix-agent \
    php5-mysql \
    monit \
    --no-install-recommends

COPY ./apache/zabbix.conf /etc/apache2/conf-available/zabbix.conf
RUN ln -s /etc/apache2/conf-available/zabbix.conf /etc/apache2/conf-enabled/

COPY ./zabbix/zabbix-server /etc/default/zabbix-server
COPY ./zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf
COPY ./zabbix/zabbix.conf.php /etc/zabbix/zabbix.conf.php

COPY ./sql/schema.sql /root/
COPY ./sql/images.sql /root/
COPY ./sql/data.sql /root/

COPY ./monit/monitrc /etc/monitrc
RUN chmod 600 /etc/monitrc
RUN mkdir /var/run/zabbix
RUN chmod 775 /var/run/zabbix

#VOLUME ["/var/lib/mysql", "/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts", "/etc/zabbix/zabbix_agentd.d"]

ADD ./scripts/run.sh /bin/start-zabbix
RUN chmod 755 /bin/start-zabbix

EXPOSE 10051 10052 80 2812
ENTRYPOINT ["/bin/start-zabbix"]
CMD ["run"]

