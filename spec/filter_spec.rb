require File.expand_path(File.dirname(__FILE__) + '/../lib/filter.rb')

# Akismet gives Filter a class to instantiate with #build during tests

module Rack::Spam::Filter
  class Akismet 
    def initialize(domain, key, post_url); end
  end 
end

include Rack

describe Rack::Spam::Filter do

  describe 'when serving as a proxy for Filter classes' do
    
    before :all do
      @service = :akismet
      @domain = 'http://copypastel.com'
      @key = '12345'
      @post_url = '/comments/'
    end
    
    it 'should instantiate a Filter class depending on :service' do
      klass = Spam::Filter.const_get(@service.to_s.capitalize)
      Spam::Filter.build(@service, @domain, @key, @post_url).class.should be(klass)
    end
    
    it 'should raise an error on trying to instantiate a Filter class that doesn\'t exist' do
      lambda { Spam::Filter.build(:tweetspam, @domain, @key, @post_url) }.should raise_error
    end
  end

end