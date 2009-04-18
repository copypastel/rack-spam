require File.expand_path(File.dirname(__FILE__) + '/../lib/filter.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/filter/akismet.rb')

include Rack::Spam

describe Rack::Spam::Filter do

  describe 'when serving as a proxy for Filter classes' do
    
    before :all do
      @service = :akismet
      @domain = 'http://copypastel.com'
      @key = '12345'
      @post_url = '/comments/'
    end
    
    it 'should instantiate a Filter class depending on :service' do
      klass = Filter.const_get(@service.to_s.capitalize)
      Filter.build(@service, @domain, @key, @post_url).class.should be(klass)
    end
    
    it 'should raise an error on trying to instantiate a Filter class that doesn\'t exist' do
      lambda { Filter.build(:tweetspam, @domain, @key, @post_url) }.should raise_error
    end
  end

  describe 'when serving as an interface for Filter classes' do

    before :all do
      @filter = Object.new.extend Filter
    end

    it 'should raise an error on checking if a request is spam.' do
      lambda { @filter.spam? }.should raise_error
    end

    it 'should raise an error on checking if a request is a comment.' do
      lambda { @filter.comment? }.should raise_error
    end

    it 'should raise an error on verifying API keys.' do
      lambda { @filter.verify? }.should raise_error
    end

    it 'should raise an error on providing the spam service name' do
      lambda { @filter.service }.should raise_error
    end

  end

end