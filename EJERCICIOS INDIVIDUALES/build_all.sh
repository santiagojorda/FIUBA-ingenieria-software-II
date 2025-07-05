#!/bin/bash

set -e

for dir in */ ; do
  cd $dir
  bundle install
  rake
  cd ..
done
