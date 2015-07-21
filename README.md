# rpi-zabbix
A docker container to run a Zabbix server on the Raspberry Pi

To run the container:
    docker pull majormjr/rpi-zabbix
    docker run -ti -p 2812:2812 -p 10051:10051 -p 10052:10052 -p 80:80 rpi-zabbix 

To build this container:
    git clone https://github.com/MajorMJR/rpi-zabbix.git
    docker build -t rpi-zabbix .
