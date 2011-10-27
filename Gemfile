source 'http://rubygems.org'

gem 'rails', :git => "git://github.com/rails/rails.git", :branch => '3-1-stable'

gem 'haml'
gem 'omniauth', :git => "git://github.com/intridea/omniauth.git", :branch => '0-3-stable'
gem 'thumbs_up'
gem 'redcarpet'
gem 'rails_config'
gem 'kaminari'
gem 'soundcloud', "~> 0.2.9"

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

group :test do
  gem 'turn', :require => false
end

group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'dalli'
end
