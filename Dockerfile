FROM alpine:latest AS builder

RUN apk add gcc musl-dev make perl

# Downloading the busybox sources
RUN wget https://busybox.net/downloads/busybox-1.35.0.tar.bz2 \
  && tar xf busybox-1.35.0.tar.bz2 \
  && mv /busybox-1.35.0 /busybox

# Gettin the content of Web CA1 from GitHub
RUN wget https://github.com/Roberttamaia/webdev_ca1/archive/main.tar.gz \
  && tar xf main.tar.gz \
  && rm main.tar.gz \
  && mv /webdev_ca1-main /home/static