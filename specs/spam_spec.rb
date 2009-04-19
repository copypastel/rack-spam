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
    @app = lambda { |env| [200, {}, "Lambda, lambda, lambda app, hoooo!"] }
  end

  before :each do
    @middleware = Spam.new @app
  end

  it 'should accept an :app and an :opts hash at instantiation' do
    lambda { Spam.new(@app, {}) }.should_not raise_error
  end
  
  it 'should return an array with status, headers, and body when sent :call' do
    @middleware.add_filter(@service, @domain, @key, @post_url)
    response = @middleware.call(@env)
    response.class.should be(Array)
    response.size.should == 3
  end

  it 'should raise an error when checking for spam if no filters have been added' do
    @middleware.filters.should be_empty
    lambda { @middleware.spam? @env }.should raise_error
  end

  it 'should be capable of adding filters' do
    @middleware.add_filter(@service, @domain, @key, @post_url)
    @middleware.filters.size.should == 1
  end
  
  it 'should check against all filters when checking for spam' do
    @middleware.add_filter(@service, @domain, @key, @post_url)
    @middleware.filters.each {|f| f.should_receive :spam?}
    @middleware.spam? @env
  end

end