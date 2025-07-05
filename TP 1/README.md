Job Vacancy Application - Equipo Caqui
========================

[![pipeline status](https://gitlab.com/fiuba-memo2/tp1/caqui/badges/prod/pipeline.svg)](https://gitlab.com/fiuba-memo2/tp1/caqui/-/commits/prod)

This is a typical web application (Ruby) with a relational database (PostgreSQL).
It is built on Padrino (web framework) and Sequel (database access framework).

## Docker Compose Development Setup

A Docker compose setup is provided with the project, to use it you just need to have Docker Compose  installed. With that in place, just execute _start_dev.sh_. This will spin up 2 Postgres instances (one for running the application and another one for running the automated tests) and a ruby container to work inside it. After spinning up the containers, the script with log you into the ruby development container.

## Developing the application

1. Run **_bundle install_**, to install all application dependencies
2. Run **_RACK_ENV=test bundle exec rake_**, to run all tests and ensure everything is properly setup
3. Run **_RACK_ENV=development bundle exec rake db:migrate db:seed_**, to setup the development database
4. Run **_bundle exec padrino start -p 3000 -h 0.0.0.0_**, to start the application

For authenticating as an offerer you can use the credentials offerer@test.com / Passw0rd!

## Running in Production mode

To run the application in production mode (that is: anywhere outside your development machine) no matter where, you should set the following environment variables:

1. RACK_ENV: this variable affects the application behaviour. For all environments outside local development machine it should be set to "production".
2. DATABASE_URL: contains the connection string to the database, it has the form "postgres://.... "
3. PORT: is the port where the application should listen
4. SMTP_X: in production mode the application needs four environment variables in order to send emails (in non-production mode, the mails are not sent but stored in the local file system). The varibales to set are: SMTP_ADDRESS, SMTP_PORT, SMTP_USER and
SMTP_PASS


## Pair/Mob Programming

If you are practicing Pair/Mob Programming and want to switch driver without running CI, then use "[driver-switch]" as your exact commit message.


## Troubleshooting

In case of adding new gem, it may be require to rebuild the containers:

    # stop containers
    docker compose stop

    # remove containers
    docker compose rm

    # start containers forcing rebuild
    docker compose up -d --build --force-recreate

```
$ docker-compose run --rm webapp bundle exec rake db:migrate
$ docker-compose up -d
$ docker-compose exec webapp /bin/bash
```
