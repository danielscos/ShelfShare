#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Only run database commands if DATABASE_URL is set
if [ -n "$DATABASE_URL" ]; then
  echo "DATABASE_URL is set, running migrations..."
  bundle exec rails db:migrate
  bundle exec rails db:seed
else
  echo "DATABASE_URL not set, skipping database setup"
fi
