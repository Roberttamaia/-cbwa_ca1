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

# Changing working directory
WORKDIR /busybox

# Installing a custom version of BusyBox
COPY .config .
RUN make && make install

# Creating a new user to secure running commands
RUN adduser -D static 

# Switching to the scratch image
FROM scratch

# Exposing container port
EXPOSE 8080

# Copying user and custom BusyBox version to the scratch image
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /busybox/_install/bin/busybox /
# Copying the content of Web CA1 to the scratch image
COPY --from=builder /home/static /home/static

# Switching to our non-root user and their working directory
USER static
## Changing working directory to /home/static/web_ca1-main
WORKDIR /home/static/webdev_ca1-main

# httpd.conf 
COPY httpd.conf .