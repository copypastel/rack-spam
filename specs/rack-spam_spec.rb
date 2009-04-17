require File.expand_path(File.dirname(__FILE__) + '/../lib/rack-spam.rb')
require File.expand_path(File.dirname(__FILE__) + '/../gem/akismet/lib/akismet')
require File.expand_path(File.dirname(__FILE__) + '/../gem/rdefensio/lib/rdefensio')
require File.expand_path(File.dirname(__FILE__) + '/../gem/ruby-mollom/lib/mollom')


describe Rack::Spam do
  
  before :all do
    config = File.open('config.yaml') {|f| YAML::load(f) }
    @domain = config[:domain]
    @akismet_key, @defensio_key, @mollom_key = [:akismet, :defensio, :mollom].map {|s| config[s]}
    @env
  end
  
  describe "#valid" do
    
    it "should check that :env is a Hash"
    it "should check that the request is a POST"
    it "should check against the POST URL"
    it "should check for :username, :email, and :comment in the input stream"
    
  end
  
  describe 'when using Akismet' do
    
    before :all do
      @filter = Rack::Spam.new(:akismet, @domain, @akismet_key)
    end
    
    it "should flag a comment" do
      @filter.spam? @env
    end
    
  end
  
  describe 'when using Defensio' do
    
    before :all do
      @filter = Rack::Spam.new(:defensio, @domain, @defensio_key)
    end
    
    it "should flag a comment" do
      @filter.spam? @env
    end
    
  end
  
  describe 'when using Mollom' do
    
    before :all do
      @filter = Rack::Spam.new(:mollom, @domain, @mollom_key)
    end
    
    it "should flag a comment" do
      @filter.spam? @env
    end
    
  end
  
end