source 'https://rubygems.org'

gem "bundler", "~> 1.3.5"
ruby '1.9.2'
gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'sqlite3'
#  gem 'debugger', :require => 'ruby-debug'
  gem 'database_cleaner'
  gem 'capybara',   '~> 2.0.3'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'simplecov'
end

group :test do
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
end


gem 'sqlite3', :group => [:development, :test]
group :production do
gem 'thin'
gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer' #, "~> 0.9.9"   
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'bootstrap-sass', '~> 3.0.2.0'
gem 'rails_12factor'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem 'haml'

gem "spreadsheet"
gem "to_xls", :git => "https://github.com/dblock/to_xls.git", :branch => "to-xls-on-models" 
gem 'prawn', '~> 1.0.0.rc1'
#gem "mail", "2.1.3"
