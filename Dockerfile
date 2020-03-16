FROM debian:buster
MAINTAINER sanjin

ENV DOMAIN=""
ENV WANNAME eth0
ENV SERVER_PORT 15901
ENV LANRANGE "192.168.0.0/24"
ENV WGSERVERIP "10.0.0.1/32"
ENV WGCLIENTIP "10.0.0.2/32"
ENV WGRANGE "10.0.0.0/24"
ENV WGNAME wg0
ENV mtu 1420
ENV PASSWORD pwd
ENV TZ=Asia/Shanghai
ENV FEC_OPTIONS "20:20"
ENV TIMEOUT 8
WORKDIR /home

ARG ARCH=amd64

ARG UDPSPEEDER_TAG_NAME=20190121.0
ARG UDPSPEEDER_FILE_NAME=speederv2_binaries.tar.gz
ARG UDPSPEEDER_DL_ADRESS="https://github.com/wangyu-/UDPspeeder/releases/download/$UDPSPEEDER_TAG_NAME/$UDPSPEEDER_FILE_NAME"
ARG UDPSPEEDER_BIN_NAME="speederv2_$ARCH"

ARG UDP2RAW_TAG_NAME=20190716.test.0
ARG UDP2RAW_FILE_NAME=udp2raw_binaries.tar.gz
ARG UDP2RAW_DL_ADRESS="https://github.com/wangyu-/udp2raw-tunnel/releases/download/$UDP2RAW_TAG_NAME/$UDP2RAW_FILE_NAME"
ARG UDP2RAW_BIN_NAME="udp2raw_$ARCH"

RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list && \
    printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable

RUN apt update \
 && apt install -y --no-install-recommends wireguard-tools iptables nano net-tools wget tar apt-utils ca-certificates curl iperf3 socat qrencode \
 && apt clean \
 && wget $UDPSPEEDER_DL_ADRESS -O $UDPSPEEDER_FILE_NAME \
 && tar -zxvf $UDPSPEEDER_FILE_NAME \
 && find ./ -type f -not -name "$UDPSPEEDER_BIN_NAME" -delete \
 && mv "/home/$UDPSPEEDER_BIN_NAME" /usr/bin/speederv2 \
 && wget $UDP2RAW_DL_ADRESS -O $UDP2RAW_FILE_NAME \
 && tar -zxvf $UDP2RAW_FILE_NAME \
 && find ./ -type f -not -name "$UDP2RAW_BIN_NAME" -delete \
 && mv "/home/$UDP2RAW_BIN_NAME" /usr/bin/udp2raw



WORKDIR /scripts
ENV PATH="/scripts:${PATH}"
COPY install-module /scripts
COPY run /scripts
COPY genkeys /scripts
RUN chmod 755 /scripts/*

CMD ["run"]
