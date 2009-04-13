require File.expand_path(File.dirname(__FILE__) + '/../lib/rack-spam.rb')
require File.expand_path(File.dirname(__FILE__) + '/../gem/akismet/lib/akismet')
require File.expand_path(File.dirname(__FILE__) + '/../gem/rdefensio/lib/rdefensio')
require File.expand_path(File.dirname(__FILE__) + '/../gem/ruby-mollom/lib/mollom')


describe Rack::Spam do
  
  before :all do
    config = File.open('config.yaml') {|f| YAML::load(f) }
    @domain = config[:domain]
  end
  
  describe 'when using Akismet' do
    
    before :all do
      @filter = Rack::Spam.new(:akismet)
    end
    
  end
  
  describe 'when using Defensio' do
    
    before :all do
      @filter = Rack::Spam.new(:defensio)
    end
    
  end
  
  describe 'when using Mollom' do
    
    before :all do
      @filter = Rack::Spam.new(:mollom)
    end
    
  end
  
end