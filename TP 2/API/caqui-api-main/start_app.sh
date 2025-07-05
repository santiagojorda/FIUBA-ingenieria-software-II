#!/bin/sh
set -e
bundle exec rake db:migrate
bundle exec ruby app.rb -p $PORT -o 0.0.0.0
