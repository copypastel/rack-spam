require File.expand_path(File.dirname(__FILE__) + '/../lib/rack-spam.rb')
require File.expand_path(File.dirname(__FILE__) + '/../gem/akismet/lib/akismet')
require File.expand_path(File.dirname(__FILE__) + '/../gem/rdefensio/lib/rdefensio')
require File.expand_path(File.dirname(__FILE__) + '/../gem/ruby-mollom/lib/mollom')


describe Rack::Spam do

  before :all do
    config = File.open('config.yaml') {|f| YAML::load(f) }
    @domain = config[:domain]
    @post_url = config[:post_url]
    @akismet_key, @defensio_key, @mollom_key = [:akismet, :defensio, :mollom].map {|s| config[s]}
    @env
  end

  describe "#comment?" do

    before :all do
      @filter = Rack::Spam.new(:akismet, @domain, @akismet_key, @post_url)
    end

    before :each do
      @env = {}
    end

    it "should accept @env as a valid comment" do
      @filter.comment?(@env).should be(true)
    end

    it "should check that the request is a POST" do
      @env[:REQUEST_METHOD] = 'GET'
      @filter.comment?(@env).should be(false)
    end

    it "should check against the comments POST URL" do
      @env[:PATH_INFO] = ''
      @filter.comment?(@env).should be(false)
    end

    it "should check for :username, :email, and :comment values in the input stream"

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