# Burn Unit

This is a work in progress... There is leftover code everywhere with no tests.

## Demo

You can play with it at: TODO

## How does it work

TODO

## Why

TODO

## How to setup

Requirements:

- [Docker](https://docs.docker.com/get-docker)
- [Docker Compose](https://docs.docker.com/compose/install)

First you will want to build the image:

```console
$ docker-compose build burn_unit
```

Then you will want to generate a new credentials file and master key:

```console
$ rm config/credentials.yml.enc
$ docker-compose run --rm burn_unit bin/rails credentials:edit
```

Once you have this set up you will want to create the database:

```console
$ docker-compose run --rm burn_unit bin/rails db:setup
```

Finally you will launch all of the services into the background:

```console
$ docker-compose up
```

Then navigate to http://localhost:3000.
