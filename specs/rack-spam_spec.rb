require 'rack'
require 'rack/lint'

require File.expand_path(File.dirname(__FILE__) + '/../lib/rack-spam.rb')
require File.expand_path(File.dirname(__FILE__) + '/../gem/akismet/lib/akismet')
require File.expand_path(File.dirname(__FILE__) + '/../gem/rdefensio/lib/rdefensio')
require File.expand_path(File.dirname(__FILE__) + '/../gem/ruby-mollom/lib/mollom')

# rack.input's StringIO is replaced with a plain string in env.yaml. 
# To maintain compatibility, String needs to respond to #read.

class String
  def read
    self
  end
end

describe Rack::Spam do

  before :all do
    config = YAML::load_file('config.yaml')
    @domain = config[:domain]
    @post_url = config[:post_url]
    @akismet_key, @defensio_key, @mollom_key = [:akismet, :defensio, :mollom].map {|s| config[s]}
  end

  describe "#new" do
    
    it "should check that :service is an actual service" do
      Rack::Spam.new(:akismet, @domain, @akismet_key, @post_url).class.should   be(Rack::Spam)
      Rack::Spam.new(:defensio, @domain, @defensio_key, @post_url).class.should be(Rack::Spam)
      Rack::Spam.new(:mollom, @domain, @mollom_key, @post_url).class.should     be(Rack::Spam)
      lambda{ Rack::Spam.new(:tweetspam, @domain, '12345', @post_url) }.should  raise_error
    end
    
  end

  describe "#comment?" do

    before :all do
      @filter = Rack::Spam.new(:akismet, @domain, @akismet_key, @post_url)
    end

    before :each do
      @env = YAML::load_file('env.yaml')
    end

    it "should accept @env as a valid comment" do
      @filter.comment?(@env).should be(true)
    end

    it "should check that the request is a POST" do
      @env['REQUEST_METHOD'] = 'GET'
      @filter.comment?(@env).should be(false)
    end

    it "should check against the comments POST URL" do
      @env['PATH_INFO'] = ''
      @filter.comment?(@env).should be(false)
    end

    it "should check for :username value in the input stream" do
      @env['rack.input'].gsub! 'username', 'user'
      @filter.comment?(@env).should be(false)
    end
    
    it "should check for :email value in the input stream" do
      @env['rack.input'].gsub! 'email', 'mail'
      @filter.comment?(@env).should be(false)
    end

    it "should check for :comment value in the input stream" do
      @env['rack.input'].gsub! 'comment', 'thoughts'
      @filter.comment?(@env).should be(false)
    end

  end

  describe 'when using Akismet' do

    before :all do
      @filter = Rack::Spam.new(:akismet, @domain, @akismet_key, @post_url)
      @spam = {}
    end

    describe '#spam?' do

      it "should flag a comment as spam" do
        @filter.spam?(@spam).should be(true)
      end

    end
    
  end

  describe 'when using Defensio' do

    before :all do
      @filter = Rack::Spam.new(:defensio, @domain, @defensio_key, @post_url)
      @spam = YAML::load_file('spam.yaml')
    end

    describe '#spam?' do

      it "should flag a comment as spam" do
        @filter.spam?(@spam).should be(true)
      end
      
    end
    
  end

  describe 'when using Mollom' do

    before :all do
      @filter = Rack::Spam.new(:mollom, @domain, @mollom_key, @post_url)
    end

    describe '#spam?' do

      it "should flag a comment as spam" do
        @filter.spam?(@spam).should be(true)
      end

    end
    
  end

end