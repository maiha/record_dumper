def __DIR__; File.dirname(__FILE__); end

$:.unshift(__DIR__ + '/../lib')

if File.exists?(__DIR__ + '/../../../rails')
  $:.unshift(__DIR__ + '/../../../rails/activesupport/lib')
  $:.unshift(__DIR__ + '/../../../rails/activerecord/lib')
else
  require 'rubygems'
end

require 'test/unit'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'

config = YAML::load_file(__DIR__ + '/database.yml')
ActiveRecord::Base.logger = Logger.new(__DIR__ + "/debug.log")
ActiveRecord::Base.colorize_logging = false
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'mysql'])

# create tables
load(__DIR__ + "/schema.rb")

# insert sample data to the tables from 'fixtures/*.yml'
Test::Unit::TestCase.fixture_path = __DIR__ + "/fixtures/"
$:.unshift(Test::Unit::TestCase.fixture_path)
Test::Unit::TestCase.use_instantiated_fixtures  = false

require __DIR__ + '/../init'
