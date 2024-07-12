# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Ruby version
3.0.2
- ` System dependencies `
* bundle install

## Configuration

## Database creation
* rails db:create

## Database initialization and tables creation
* rails db:init
* rails db:migrate
* rails db:migrate RAILS_ENV=test

## How to run the test suite
* rails db:test:prepare
* bundle exec rspec
* bundle exec rspec --fail-fast (to stop at the first error)


## Services (job queues, cache servers, search engines, etc.)
- ` install redis before `
* redis-cli flushall ` (services restart redis) `
* bundle exec sidekiq -q default -q mailers ` (run sidekiq) `

# Deployment instructions
* rails server

## Install Postgre on Windows for ruby 3.0.2
- ` open the command line (cmd) as administrator `
* run "ridk install" to install the ridk tool
* run "ridk exec pacman -S mingw-w64-x86_64-postgresql" to install Postgres using pacman
* then reinstall the Postgres gem by running "bundle" or "bundle install"

## Assign/remove admin role to a user
- In the .env file assign to ADMIN_USER environment variable the  the id of the user you want to assign/remove the admin role. e.g ADMIN_USER = 1
- restart rails with "crlt+c"/"cmd+c" and "rails s"
- run the rake task "rake set_admin" to assign the admin role or "rake remove_admin" to remove the admin role

* Create a theme
- Open the file "elearning-api/lib/tasks/create_theme.rake" and possibly modify with a new theme
- run "rake create_theme" to create a new theme

* Create a school
- Open the file "elearning-api/lib/tasks/create_school.rake" and possibly modify with a new school
- run "rake create_school" to create a new school

## Create a user
- ` Open the file "elearning-api/lib/tasks/create_user.rake `
- ` edit the content of the file with you credentials `
* run "rake create_user"

# Attach files to the table schools
* run "rake school_attachment[id]" where id is the associated record

## Attach files to the table themes
* run "rake theme_attachment[id]" where id is the associated record

# populate RESOURCES
- ` set the variable ADMIN_USER in the .env with the id of the user that will populate the resources `
- ` set the variable NUMBER_OF_RECORDS to define the number of resource you want to populate `
## Populate schools
  * run "rake populate_schools" to populate schools
  - ` NB: root_id and parent_id for each created school is the id of root school SYSAIT.  If it does exist, it is created `
  - ` NB: the them_id is the id of the first theme in the DB `
## populate news
  - ` set in .env the environment variable SCHOOL_ID to insert the school in which populate the news `
  * run "rake populate_news" to populate news
## populate students
  - ` set in .env the environment variable SCHOOL_ID, SCHOLASTIC_PERIOD_ID (if SCHOLASTIC_PERIOD_ID does not exist it creates automatically one) `
  * run "rake populate_students"
## populate scolastic periods
  - ` set in .env the environment variable SCHOOL_ID, ADMIN_USER and  NUMBER_OF_RECORDS `
  * run "rake populate_scolastic_periods"
## populate cycles
  - ` set in .env the environment variable ADMIN_USER, SCHOLASTIC_PERIOD_ID and NUMBER_OF_RECORDS`
  * run "rake populate_cycles"
## populate locals
  - ` set in .env the environment variable SCHOOL_ID, ADMIN_USER and  NUMBER_OF_RECORDS `
  * run "rake populate_locals"
## populate evaluation types
  - ` set in .env the environment variable SCHOOL_ID, ADMIN_USER and  NUMBER_OF_RECORDS `
  * run "rake populate_evaluation_types"
## populate departments
  - ` set in .env the environment variable SCHOOL_ID, ADMIN_USER`
  * run "rake populate_departments"
## populate jobs
  - ` set in .env the environment variable SCHOOL_ID, ADMIN_USER`
  * run "rake populate_jobs"
## populate profiles
  - ` set in .env the environment variable SCHOOL_ID, ADMIN_USER and  NUMBER_OF_RECORDS `
  * run "rake populate_profiles"

  ## create staff
` 1 => school_id `
` 5 => profile_id `
` true => is school_admin `
bundle exec rake "staff:create[1,5,pippo.papperino2@gmail.com,Test1test,true]"

