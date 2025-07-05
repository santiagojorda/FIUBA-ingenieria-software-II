#!/bin/sh
set -x
APP_MODE=development bundle exec rdbg --open -n -c -- bundle exec ruby app.rb
