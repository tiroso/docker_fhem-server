FROM fhem/fhem

MAINTAINER Tim Sobisch

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

RUN apt-get update \
	&& apt-get -qqy --no-install-recommends \
		build-essential \
		cpanminus \
	&& cpanm Net::WebSocket::Server \
	&& apt-get purge -qqy \
        	build-essential \
		cpanminus \
	&& rm -rf /root/.cpanm \
	&& apt-get purge -qqy \
		build-essential \
		cpanminus \
	&& apt-get autoremove -qqy && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
