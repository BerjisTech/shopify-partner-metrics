# README

This README would normally document whatever steps are necessary to get the
application up and running.

# TODO: 

Change action mailer to actual domain on environments/production.rb

```ruby
config.action_mailer.default_url_options = { host: 'example.com', port: 3000 }
```

Change the default order by for the models using

```ruby
self.implicit_order_column = 'created_at'
```

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

### CAPISTRANO
Post-install message from capistrano-passenger:
==== Release notes for capistrano-passenger ====
passenger once had only one way to restart: `touch tmp/restart.txt`
Beginning with passenger v4.0.33, a new way was introduced: `passenger-config restart-app`

The new way to restart was not initially practical for everyone,
since for versions of passenger prior to v5.0.10,
it required your deployment user to have sudo access for some server configurations.

capistrano-passenger gives you the flexibility to choose your restart approach, or to rely on reasonable defaults.

If you want to restart using `touch tmp/restart.txt`, add this to your config/deploy.rb:

    set :passenger_restart_with_touch, true

If you want to restart using `passenger-config restart-app`, add this to your config/deploy.rb:

    set :passenger_restart_with_touch, false # Note that `nil` is NOT the same as `false` here

If you don't set `:passenger_restart_with_touch`, capistrano-passenger will check what version of passenger you are running
and use `passenger-config restart-app` if it is available in that version.

If you are running passenger in standalone mode, it is possible for you to put passenger in your
Gemfile and rely on capistrano-bundler to install it with the rest of your bundle.
If you are installing passenger during your deployment AND you want to restart using `passenger-config restart-app`,
you need to set `:passenger_in_gemfile` to `true` in your `config/deploy.rb`.
================================================

* ...
