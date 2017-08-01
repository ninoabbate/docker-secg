FROM alpine:3.6

MAINTAINER Antonino Abbate "ninoabbate@gmail.com"

# NOTE: this ENV is populated when running the build script
# if you need to build manually the container just populate it with the release tag
ENV APP_VERSION

# snmp exporter config generator
RUN apk --no-cache add go git net-snmp net-snmp-tools net-snmp-dev alpine-sdk \
	&& mkdir -p $HOME/.snmp/mibs \
	&& go get github.com/prometheus/snmp_exporter/generator \
	&& cd /root/go/src/github.com/prometheus/snmp_exporter \
	&& git checkout tags/${APP_VERSION} \
	&& cd generator \
	&& go build

ADD generator.yml /snmp_exporter/generator/

CMD /bin/sh -c 'cd /root/go/src/github.com/prometheus/snmp_exporter/generator; ./generator generate'
