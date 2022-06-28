# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

### Ruby version
Ruby 3.0.1

### System dependencies

### Configuration
Clone the project locally.

``` shell
$ git clone git@github.com:berjistech/metrics.git
```

Switch to staging and pull

``` shell
$ git checkout staging
$ git pull
```

Create a new branch. Follow the naming convention to make work easier for everyone else
Convention: branch_type/title/task_id
The task Id will be gotten from clickup
 branch_type can be feature, chore, sprint, bugfix or patch
eg

``` shell
$ git checkout -b feature/image_sharing/Qt4rYz
```
or

``` shell
$ git checkout -b bugfix/remove_redundant_comment/1253623
```

Once you've created the new branch, push your work and create a pull request AGAINST STAGING (no PR against master/ main will be accepted)

### Database creation
Change the db configs on /cofig/database.yml to match your local setup then run normal ruby and postgress commands
``` shell
$ rake db:setup
$ rake db:migrate
```

If you run into issues try

``` shell
$ rake db:reset
```


### Database initialization
Check for seed files and make sure you've saved that data before running the app
``` shell
$ rake db:seed
```

For Admin you'll need to create an activeadmin user

``` shell
$ rails c
irb(main):001:0> AdminUser.create!(email: 'youremail@example.dns', password: 'password', password_confirmation: 'password')
```

Or just ask an existing AdminUser to add you from the active adimin dashboard

### How to run the test suite

### Services (job queues, cache servers, search engines, etc.)

### Deployment instructions

- Add an SSH key to digital ocean
- Use root to create your user
``` bash
adduser your_username
```
- Add the new user to sudo group
``` bash
mkdir -p /home/your_username/.ssh
cp ~/.ssh/authorized_keys /home/your_username/.ssh
chown -R your_username:your_username /home/your_username/.ssh/

usermod -aG sudo your_username
vi /etc/sudoers
# add the following line at the bottom
your_username  ALL=(ALL) NOPASSWD: ALL
```
Once your user has ssh access to the droplet, check prometheus, the project is under /home/prometheus/ltvsaasgrowth (check /config/deploy.rb line 10)

Create a PR against staging and request review from at least 3 members. The branch should have a staging server on heroku (or ngrok if it's something small) for testing purposes.
Once everything is verified, the branch will be m,erged with main:master then deployed to production
ctions


- For Production
Simply run cap deploy

``` ruby
cap production deploy
```

All capistrano configs are set on the different cap files
- capfile
- /config/deploy.rb
- /config/deploy/production.rb

Check these links for further details on rails capistrano deploy

- [Puma Deploy](https://webdevchallenges.com/how-to-deploy-a-rails-6-application-with-capistrano)
- [Passenger deploy](https://gorails.com/deploy/ubuntu/20.04)

This project uses passenger but the puma doc is also helpful in some steps

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

    set :passenger_restart_with_touch, false 

Note that `nil` is NOT the same as `false` here

If you don't set `:passenger_restart_with_touch`, capistrano-passenger will check what version of passenger you are running
and use `passenger-config restart-app` if it is available in that version. If you are running passenger in standalone mode, it is possible for you to put passenger in your Gemfile and rely on capistrano-bundler to install it with the rest of your bundle. If you are installing passenger during your deployment AND you want to restart using `passenger-config restart-app`, you need to set `:passenger_in_gemfile` to `true` in your `config/deploy.rb`.
* ...
