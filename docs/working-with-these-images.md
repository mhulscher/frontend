Below you will find several examples to work with these images.

## FlatIron application, Dockerfile.test
```
FROM docker1-registry.twobridges.io/frontend:test-0
MAINTAINER Mitch Hulscher "mitch.hulscher@nepworldwide.nl"

COPY . /var/www/html
```

## FlatIron application, Dockerfile
```
FROM docker1-registry.twobridges.io/frontend:0
MAINTAINER Mitch Hulscher "mitch.hulscher@nepworldwide.nl"

ADD dist/prod/ /var/www/html
```

## Testing your application inside the container

Here we assume that you will install the required libraries and dependencies locally. We then mount the application inside the base container and run it.

```
$ git clone my-app
$ cd my-app
$ npm install
$ docker pull docker1-registry.twobridges.io/frontend:0
$ docker run --rm \
  -tip 80:80 \
  -v $PWD/dist/prod:/var/www/html \
  docker1-registry.twobridges.io/frontend:0
$ curl -siXGET 127.0.0.1
```

## Build image like Bamboo

Bamboo uses its shared caches to quickly install libraries and dependencies. In the following example we mount these caches when running the build. Note that first mount will contain our artifact. We will use this artifact to build to final image.

```
$ git clone my-app
$ cd my-app
$ docker build --force-rm -t my-app:test -f Dockerfile.test .
$ docker run --rm \
  -v $PWD/dist:/var/www/html/dist \
  -v $HOME/.jspm:/jspm \
  -v $HOME/.node_gyp:/node_gyp \
  -v $HOME/.npm:/npm \
  -v $HOME/.ssh:/ssh \
  my-app:test install
$ docker build --force-rm -t my-app:latest -f Dockerfile .
$ docker run --rm -tip 80:80 my-app:latest
```
