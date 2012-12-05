source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'rb-readline' #needed for Ian's machine
gem 'nokogiri' #needed for xml parsing
gem 'will_paginate', '~> 3.0'
gem 'timecop' #used to set time for cucumber
gem 'omniauth'
gem 'omniauth-facebook'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# for Heroku deployment
group :development, :test do
  gem 'sqlite3'
  gem 'debugger'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl', '~> 2.2'
	gem 'railroady'
end
group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'simplecov'
end
group :production do
  gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "3.1.6"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'therubyracer'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem "rspec-rails", "~> 2.0"
gem 'haml'
gem 'sass', '3.1.10'
gem 'bootstrap-sass', '~> 2.1.0.1'
gem 'devise'
