### SoundCloud Competition

Competitions, powered by [SoundCloud](http://soundcloud.com).

1. Add key and secret to "/config/settings/production.local.yml"
2. For local development, run bundle install
3. heroku create app_name --stack cedar
4. git push heroku master
5. heroku run rake db:setup
6. heroku addons:add memcache
7. Claim admin by visiting /admin and logging in