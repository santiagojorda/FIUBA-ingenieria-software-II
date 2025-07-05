#!/bin/sh
set -e 

docker-compose up -d
docker-compose exec web /bin/bash
