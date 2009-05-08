require 'rack'

require File.expand_path(File.dirname(__FILE__) + '/../lib/spam.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/filter.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/filter/akismet.rb')

include Rack

describe Rack::Spam do

  # Set up configuration variables

  before :all do
    @service = :akismet
    @domain = 'http://copypastel.com'
    @key = 'e56eb5d6b47c'
    @post_url = '/comments'
    @env = Rack::MockRequest.env_for('/comments', {:input => "username=ecin&email=ecin@copypastel.com&comment=This is awesome!"})
    # The Lambdacat App
    @app = lambda { |env| [200, {}, "Lambda, lambda, lambda app, hoooo!"] }
  end

  # Rack::Spam middleware can be instantiated
  it 'should accept an :app and an :opts hash at instantiation' do
    lambda { Spam.new(@app, {}) }.should_not raise_error
  end
  
  # :opts defines the settings for Rack::Spam
  it 'should set filters given their parameters in the :opts hash' do
    middleware = Spam.new(@app, :domain => 'http://copypastel.com', 
                                :post_url => '/comments', 
                                :services => {:akismet => '12345'})
    middleware.filters.size.should == 1
  end
  
  before :each do
    @middleware = Spam.new @app
  end
  
  # Rack::Spam#call is defined, as in any middleware
  it 'should return an array with status, headers, and body when sent :call' do
    @middleware.add_filter(@service, @domain, @key, @post_url)
    response = @middleware.call(@env)
    response.class.should be(Array) 
    response.size.should == 3
    response[2] == "Lambda, lambda, lambda app, hoooo!"
  end

  # Rack::Spam can't do its work without any filters to do the spam checking
  it 'should raise an error when checking for spam if no filters have been added' do
    @middleware.filters.should be_empty
    lambda { @middleware.spam? @env }.should raise_error
  end

  # We can fix the empty filter set problem
  it 'should be capable of adding filters' do
    @middleware.add_filter(@service, @domain, @key, @post_url)
    @middleware.filters.size.should == 1
  end
  
  # First step is to check if the incoming request is a comment and should be checked for spam
  it 'should check that the request is a comment when called' do
    @middleware.add_filter(@service, @domain, @key, @post_url)
    @middleware.should_receive :comment?
    @middleware.call @env
  end
  
  # Each request (assuming it's a comment) is wrung through all the filters
  it 'should check against all filters when called' do
    @middleware.add_filter(@service, @domain, @key, @post_url)
    @middleware.filters.each {|f| f.should_receive :spam?}
    @middleware.call @env
  end

end