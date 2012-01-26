  source 'http://rubygems.org'

  gem 'rails', '~>3.0.10'

  gem 'blacklight', '~> 3.1.2'

#  gem "hydra-head", :path => "../../hydra/hydra-head"
  gem "hydra-head", :git => "git://github.com/projecthydra/hydra-head.git", :branch=>'master'
#  gem 'hydra-head', '3.1.5'

  gem 'active-fedora', '>=3.2.0'
#  gem "active-fedora", :path => "../../hydra/active_fedora"

  # We will assume that you're using sqlite3 for testing/demo, 
  # but in a production setup you probably want to use a real sql database like mysql or postgres
  gem 'sqlite3-ruby', :require => 'sqlite3'

  #  We will assume you're using devise in tutorials/documentation. 
  # You are free to implement your own User/Authentication solution in its place.
  gem 'devise'

  # For testing.  You will probably want to use all of these to run the tests you write for your hydra head
  group :development, :test do 
         gem 'solrizer-fedora', '>=1.0.1'
         gem 'ruby-debug'
         gem 'rspec'
         gem 'rspec-rails', '>=2.5.0'
         gem 'mocha'
         gem 'cucumber-rails'
         gem 'database_cleaner'
         gem 'capybara'
         gem 'bcrypt-ruby'
         gem "jettywrapper"
         gem 'rest-client'
	
	 # Added 
	 gem 'net-http-digest_auth'

	 gem 'rubyhorn', :git => "git://github.com/cjcolvar/rubyhorn.git"

	 gem 'mediashelf-loggable'
  end
gem "devise"
