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
  end

  it 'should raise an error when checking for spam if no filters have been added' do
    Spam.filters.should be_empty
    lambda { Spam.spam? @env }.should raise_error
  end

  it 'should be capable of adding filters' do
    Spam.add_filter(@service, @domain, @key, @post_url)
    Spam.filters.size.should == 1
  end
  
  it 'should check against all filters when checking for spam' do
    Spam.filters.each {|f| f.should_receive :spam?}
    Spam.spam? @env
  end

end