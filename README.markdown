### SoundCloud Competition

1. Add key and secret to "/config/settings/production.local.yml"
2. heroku create app_name --stack cedar
3. git push heroku master
4. heroku run rake db:seed
5. heroku addons:add memcache
6. Claim admin by visiting /admin and logging in