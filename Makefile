 # Helper Makefile for Sysait Developers

SHELL := /bin/bash

# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
install-pre-commit:
	pip install pre-commit
	pre-commit install
enable-pre-commit: # make the pre-commit hook executable
	mv pre-commit .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
	rm db/schema.rb
	rails db:schema:dump
dev: ## start dev server
	bundler exec rails s -p 3033

unit-test: ## start unit tests
	bundler exec rails db:test:prepare && \
	bundle exec rspec --fail-fast
	
migrations: ## Database initialization and tables creation
	bundler exec rails db:migrate && \
	bundler exec rails db:migrate RAILS_ENV=test

rollback: ## rollback the last migrations
	bundler exec rake db:rollback  STEP=1
	bundler exec rake db:rollback  STEP=1 RAILS_ENV=test

dependencies: ## System dependencies
	bundle install

sidekiq: ## Services (job queues, cache servers, search engines, etc.)
	redis-cli flushall && \
	bundle exec sidekiq -q default -q mailers
enable_cache: ## Enable cache
	rails dev:cache

decodes: ## Decode
	rake decodes

decodes_common: ## Decode common
	rake decodes\[common\]

decodes_school: ## Decode school
	rake decodes\[school\]

set_up_resource:
	bundle exec rake create_user
	bundle exec rake create_theme
	bundle exec rake create_root_school
	bundle exec rake decodes\[school\] 
	bundle exec rake decodes\[common\]

initialize_resource:
	bundle exec rake populate_schools
	bundle exec rake populate_scholastic_periods
	bundle exec rake "staff:create[1,5,pippo.papperino2@gmail.com,Test1test,true]"


set_up_test_env:
	bundle exec rake create_user RAILS_ENV=test
	bundle exec rake create_theme RAILS_ENV=test
	bundle exec rake create_root_school RAILS_ENV=test
	bundle exec rake decodes\[school\] RAILS_ENV=test
	bundle exec rake decodes\[common\] RAILS_ENV=test

generate_eer_diagram:
	bundle exec erd
