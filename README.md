# Showcase of Rails 4 and AngularJS integration

The _original_ is [here](https://github.com/mkwiatkowski/todo-rails4-angularjs). This fork includes:

 - Dockerized app
 - All specs are passing
 - Authentication against Google OAuth2
 - A button to share task lists on Facebook

# Getting started

After cloning this repo locally, create your `.env` file as follows:

```
POSTGRES_PASSWORD=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
```

The PostgreSQL is your choice, and the Google client details can be obtained as [described here](https://github.com/zquestz/omniauth-google-oauth2#google-api-setup).

## Docker & docker-compose

Please refer to the [official Docker docs](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) on how to install the required software to successfully check the running Rails app.

The `docker-composer` file will bring up the app image running as an unprivileged user, and will take care of PostgreSQL database server as well.

Inside the app directory, build the local image:

```shell
➜  todo-rails4-angularjs git:(add/oauth-and-fb-share-button) docker-compose build
db uses an image, skipping
Building app
Step 1/28 : FROM ubuntu:bionic
 ---> 735f80812f90
Step 2/28 : RUN apt update &&   apt upgrade -y -qq &&   DEBIAN_FRONTEND=noninteractive apt -y install build-essential git   wget imagemagick unzip phantomjs libxml2-dev libxslt-dev   libffi-dev libyaml-dev libgdbm-dev libreadline-dev libmysqlclient-dev   apt-utils libpq-dev ncurses-dev sqlite3 libsqlite3-dev   silversearcher-ag screen cron tzdata dash chromium-chromedriver   libssl1.0-dev nodejs sudo
 ---> Using cache
 ---> 0aca2730e087
 ...
 Successfully built 942118b897cc
 Successfully tagged todo-rails4-angularjs_app:latest
```

Once it finishes, it's time to run the containers:
```shell
➜  todo-rails4-angularjs git:(add/oauth-and-fb-share-button) docker-compose up
todo-rails4-angularjs_db_1 is up-to-date
Recreating todo-rails4-angularjs_app_1 ... done
Attaching to todo-rails4-angularjs_db_1, todo-rails4-angularjs_app_1
app_1  | wait-for-it.sh: waiting 15 seconds for db:5432
...
app_1  | Starting the Rails server...
app_1  | [2018-09-07 02:15:12] INFO  WEBrick 1.3.1
app_1  | [2018-09-07 02:15:12] INFO  ruby 2.2.4 (2015-12-16) [x86_64-linux]
app_1  | [2018-09-07 02:15:12] INFO  WEBrick::HTTPServer#start: pid=136 port=3000
```

When you see the message above, please open your browser in [http://localhost:3000](http://localhost:3000) and the app will be ready for use.

## Specs

It's possible to run the specs this way:

```shell
➜  todo-rails4-angularjs git:(add/oauth-and-fb-share-button) ✗ docker-compose run --service-ports -e RAILS_ENV=test --rm app bundle exec rake db:migrate
Starting todo-rails4-angularjs_db_1 ... done
➜  todo-rails4-angularjs git:(add/oauth-and-fb-share-button) ✗ docker-compose run --service-ports -e RAILS_ENV=test --rm app bundle exec rspec
Starting todo-rails4-angularjs_db_1 ... done
DEPRECATED: #default_wait_time= is deprecated, please use #default_max_wait_time= instead

Randomized with seed 12587
.............................................................

Deprecation Warnings:

Using `should` from rspec-expectations' old `:should` syntax without explicitly enabling the syntax is deprecated. Use the new `:expect` syntax or explicitly enable `:should` with `config.expect_with(:rspec) { |c| c.syntax = :should }` instead. Called from /home/deploy/current/spec/models/user_spec.rb:8:in `block (3 levels) in <top (required)>'.


If you need more of the backtrace for any of these deprecations to
identify where to make the necessary changes, you can configure
`config.raise_errors_for_deprecations!`, and it will turn the
deprecation warnings into errors, giving you the full backtrace.

1 deprecation warning total

Finished in 8.69 seconds (files took 3.11 seconds to load)
61 examples, 0 failures

Randomized with seed 12587
```
