require 'rack/test'
require 'rspec'


ENV['RACK_ENV'] = 'test'

require File.expand_path '../../receive_books.rb', __FILE__
Dir["#{Dir.pwd}/lib/**/**/*.rb"].each { |file| require file }

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }
