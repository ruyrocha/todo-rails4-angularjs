#!/usr/bin/env bash

echo "Dropping databases..."
bundle exec rake db:drop
echo "Creating databases..."
bundle exec rake db:create
echo "Migrating..."
bundle exec rake db:migrate
echo "Seeding..."
bundle exec rake db:seed
echo "Removing stale PID file"
/bin/rm tmp/pids/server.pid
echo "Starting the Rails server..."
bundle exec rails server
