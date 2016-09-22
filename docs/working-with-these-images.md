Below you will find several examples to work with these images.

## FlatIron application, Dockerfile.test
```
FROM docker1-registry.twobridges.io/frontend:test-0
MAINTAINER Mitch Hulscher "mitch.hulscher@nepworldwide.nl"

COPY . /var/www/html
```

## FlatIron applicatino, Dockerfile
```
FROM docker1-registry.twobridges.io/frontend:0
MAINTAINER Mitch Hulscher "mitch.hulscher@nepworldwide.nl"

ADD dist/prod/ /var/www/html
```
