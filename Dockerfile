FROM alpine:3.6 as builder
MAINTAINER Antonino Abbate "ninoabbate@gmail.com"

# NOTE: this ENV is populated when running the build script
# if you need to build manually the container just populate it with the release tag
ENV APP_VERSION

# snmp exporter config generator
RUN apk --no-cache add go git net-snmp net-snmp-tools net-snmp-dev alpine-sdk \
    && go get github.com/prometheus/snmp_exporter/generator \
	&& cd /root/go/src/github.com/prometheus/snmp_exporter \
	&& git checkout tags/${APP_VERSION} \
	&& cd generator \
	&& go build -a -ldflags '-extldflags "-static -lcrypto -ldl"'

FROM quay.io/prometheus/busybox:latest

ADD generator.yml .
RUN mkdir -p $HOME/.snmp/mibs
COPY --from=builder /root/go/src/github.com/prometheus/snmp_exporter/generator/generator /bin/generator

ENTRYPOINT ["/bin/generator"]
CMD ["generate"]
