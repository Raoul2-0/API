#!/bin/bash
export RAILS_ENV=test
bundler exec rails db:test:prepare
bundler exec rails db:migrate RAILS_ENV=test
bundle exec rspec --fail-fast
exit_code=$?
if [ $exit_code -ne 0 ]; then
  exit $exit_code
fi
echo "All unit tests passed"