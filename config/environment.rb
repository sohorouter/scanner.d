# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Eins::Application.initialize!


#CouchFoo::Base.set_database(:host => 'http://192.168.0.195:5984', :database=>'eins')
#CouchFoo::Base.logger = Rails.logger

CouchPotato::Config.database_name='http://192.168.0.195:5984/eins'
puts 'environment'

