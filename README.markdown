### SoundCloud Competition

1. Create "settings" folder within config
2. Create file "production.local.yml" and add key and secret
3. heroku create app_name --stack cedar
4. git push heroku master
5. heroku run rake db:migrate
6. heroku run rake db:seed
7. heroku addons:add memcache
8. Claim admin by visiting /admin and logging in