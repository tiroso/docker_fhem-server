FROM fhem/fhem

MAINTAINER Tim Sobisch

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

RUN apt-get update \
	&& apt-get -y install \
		libwebsockets-dev
