FROM nginx:alpine
MAINTAINER mitch.hulscher@lib.io

RUN apk --update add curl \
 && curl \
      --silent \
      --location \
      https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 \
    | gzip > /usr/bin/confd.gz \
 && apk del curl \
 && rm -f /etc/nginx/conf.d/* /var/cache/apk/*

COPY files/html/index.html          /var/www/html/index.html
COPY files/nginx/nginx.conf         /etc/nginx/nginx.conf
COPY files/nginx/001-logformat.conf /etc/nginx/conf.d/001-logformat.conf
COPY files/confd                    /etc/confd
COPY files/scripts/run.sh           /opt/run.sh

WORKDIR "/var/www/html"
EXPOSE 80 443
CMD "/opt/run.sh"
