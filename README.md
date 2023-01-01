# Burn Unit

This is a work in progress... There is leftover code everywhere with no tests.

## Demo

You can play with it at: https://bu.nicklas.cloud/

## How does it work

This is meant to only facilitate actual in-person game play. Someone starts off
as a judge for the rounds and enters a question. Each player that joins votes
for the most (or least) likely candidate. After the votes are tallied the
person with the most votes accumulates their votes as their score.

This game does not keep track of each individual players' score. The player
with the highest score whenever you choose to end the game is considered to
have lost. In the case of a tie during a round then the judge should probably
decide who wins that round (but this is up to the players and not part of the
online game).

## Why

My family enjoys party games but we find writing answers down on paper and
passing them around to be cumbersome. This makes playing the game easier.

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
