### SoundCloud Competition

1. Add key and secret to "/config/settings/production.local.yml"
2. For local development, run bundle install --without production
3. heroku create app_name --stack cedar
4. git push heroku master
5. heroku run rake db:seed
6. heroku addons:add memcache
7. Claim admin by visiting /admin and logging in