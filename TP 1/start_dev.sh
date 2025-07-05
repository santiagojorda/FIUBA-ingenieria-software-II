#!/bin/bash

set -e

docker-compose run --rm webapp bundle install
docker-compose run --rm webapp bundle exec rake db:migrate
docker-compose up -d
docker-compose exec webapp /bin/bash
