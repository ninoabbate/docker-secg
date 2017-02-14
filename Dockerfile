FROM alpine:3.5

MAINTAINER Antonino Abbate "ninoabbate@gmail.com"

RUN apk --update add go git net-snmp net-snmp-tools net-snmp-dev g++

# snmp exporter config generator
RUN mkdir -p $HOME/.snmp/mibs \
	&& mkdir $HOME/work \
	&& export GOPATH=$HOME/work \
	&& git clone --branch v2 https://github.com/go-yaml/yaml $GOPATH/src/gopkg.in/yaml.v2 \
	&& cp /usr/lib/libnetsnmp.so.30 /usr/lib/libsnmp.so \
	&& git clone https://github.com/prometheus/snmp_exporter.git \
	&& cd /snmp_exporter/generator \
	&& go get -d \
	&& go build

ADD generator.yml /snmp_exporter/generator/

CMD /bin/sh -c 'cd /snmp_exporter/generator; ./generator generate'
