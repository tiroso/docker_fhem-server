FROM debian:stretch

MAINTAINER Tim Sobisch

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm


RUN touch /sbin/init \
	&& apt-get update \
	&& apt-get -y install \
		apt-utils  \
		procps \
		wget \
		python \
		gnupg \
		build-essential \
		dfu-programmer \
		etherwake \
		snmp \
		snmpd \
		usbutils \
		apt-transport-https  \
		telnet  \
		sqlite3  \
		libdbi-perl \ 
		libdbd-sqlite3-perl \
		cpanminus \
		libwww-perl\
		libsoap-lite-perl \
		libxml-parser-perl \
		libxml-parser-lite-perl \
		libnet-telnet-perl \
	&& cpanm Net::WebSocket::Server \
	&& cpanm JSON \
	&& cpanm XML::Parser::Lite \
	&& wget -O /usr/local/bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py \
	&& chmod +x /usr/local/bin/speedtest-cli \
	&& wget -qO - https://debian.fhem.de/archive.key | apt-key add -  \
	&& echo "deb http://debian.fhem.de/nightly/ /" | tee -a /etc/apt/sources.list.d/fhem.list \
	&& apt-get update \
	&& apt-get -y install \
		fhem 
RUN pkill -f "fhem.pl" \
	&& update-rc.d -f fhem remove \
	&& userdel fhem \
	&& rm /opt/fhem/log/*.log \
	&& mkdir /backup \
	&& usermod -aG dialout root \
	&& chmod -R a+w /opt \
	&& chown -R root:dialout /opt \ 
	&& apt-get clean  \
	&& apt-get autoclean  \
	&& apt-get autoremove -y  \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
COPY configDB.conf /opt/fhem/configDB.conf
COPY logDB.conf /opt/fhem/logDB.conf

RUN echo "pragma auto_vacuum=2;" | sqlite3 /opt/fhem/configDB.db \
    && echo "CREATE TABLE 'history' (TIMESTAMP TIMESTAMP, DEVICE varchar(64), TYPE varchar(64), EVENT varchar(512), READING varchar(64), VALUE varchar(128), UNIT varchar(32));\
    CREATE TABLE 'current' (TIMESTAMP TIMESTAMP, DEVICE varchar(64), TYPE varchar(64), EVENT varchar(512), READING varchar(64), VALUE varchar(128), UNIT varchar(32));\
    CREATE INDEX Search_Idx ON 'history' (DEVICE, READING, TIMESTAMP);"\
    | sqlite3 /opt/fhem/log/logDB.db;

RUN sed -i '/global nofork/d' /opt/fhem/fhem.cfg \
	&& sed -i "1iattr global nofork 1" /opt/fhem/fhem.cfg

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

CMD ["fhem-run"]
