#!/bin/sh

set -e
set -x

bundle exec rake db:migrate db:seed
bundle exec padrino start -p ${PORT:-3000} -h 0.0.0.0
