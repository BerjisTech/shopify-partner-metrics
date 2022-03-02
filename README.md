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

* ...
