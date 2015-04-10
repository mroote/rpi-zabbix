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
    monit \
    --no-install-recommends

COPY ./apache/zabbix.conf /etc/apache2/conf-available/zabbix.conf
RUN ln -s /etc/apache2/conf-available/zabbix.conf /etc/apache2/conf-enabled/

COPY ./sql/schema.sql /root/
COPY ./sql/images.sql /root/
COPY ./sql/data.sql /root/

ADD ./scripts/run.sh /bin/start-zabbix
RUN chmod 755 /bin/start-zabbix

ADD ./monit/monitrc /etc/monitrc
RUN chmod 600 /etc/monitrc

EXPOSE 10051 10052 80
ENTRYPOINT ["/bin/bash"]

