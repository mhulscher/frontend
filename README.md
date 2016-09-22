# frontend

The `nginx-php-fpm` builds several Docker-images that you can use as a base for your own frontend projects. The following Docker-images are produced:

* frontend:latest
* frontend:test-latest

## Development

This repository and its resulting images are supported by the NEP System Operations team.

* HipChat: #Beheer or #System Operations
* E-mail: systeembeheer@nepworldwide.nl

## Building and using

Place two files in your project: `Dockerfile.test` and `Dockerfile`.

* `Dockerfile.test` should use a *-test-latest image as base.
* `Dockerfile` should use a *-latest image as base. 

## Next steps

Check out the [docs directory](docs) for more docs.
