FROM nginx:alpine
MAINTAINER Mitch Hulscher "mitch.hulscher@nepworldwide.nl"

RUN echo 'Europe/Amsterdam' > /etc/timezone \
 && rm -f /etc/localtime \
 && ln -vs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

COPY nginx/index.html         /var/www/html/index.html
COPY nginx/nginx.conf         /etc/nginx/nginx.conf
COPY nginx/www.conf           /etc/nginx/conf.d/www.conf
COPY nginx/001-logformat.conf /etc/nginx/conf.d/001-logformat.conf
COPY scripts/run.sh           /opt/run.sh

CMD "/opt/run.sh"
