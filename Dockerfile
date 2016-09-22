FROM nginx:alpine
MAINTAINER Mitch Hulscher "mitch.hulscher@nepworldwide.nl"

RUN echo 'Europe/Amsterdam' > /etc/timezone \
 && rm -f /etc/localtime \
 && apk --update add tzdata curl \
 && cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime \
 && curl -Lo /usr/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 \
 && chmod +x /usr/bin/confd \
 && apk del tzdata curl \
 && rm -f /etc/nginx/conf.d/* /var/cache/apk/*

COPY files/html/env.js              /var/www/html/env.js
COPY files/html/favicon.ico         /var/www/html/favicon.ico
COPY files/html/index.html          /var/www/html/index.html
COPY files/nginx/nginx.conf         /etc/nginx/nginx.conf
COPY files/nginx/001-logformat.conf /etc/nginx/conf.d/001-logformat.conf
COPY files/confd                    /etc/confd
COPY files/scripts/run.sh           /opt/run.sh

WORKDIR "/var/www/html"
EXPOSE 80 443
CMD "/opt/run.sh"
