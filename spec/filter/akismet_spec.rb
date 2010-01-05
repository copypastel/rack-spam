require File.expand_path(File.dirname(__FILE__) + '/../../lib/spam.rb')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/filter.rb')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/filter/akismet.rb')

include Rack

describe Rack::Spam::Filter::Akismet do

  # Avoid namespace conflict with akismet gem class
  Akismet = Rack::Spam::Filter::Akismet

  before :all do
    env_yaml = File.expand_path(File.dirname(__FILE__) + '/../env.yaml')
    spam_yaml = File.expand_path(File.dirname(__FILE__) + '/../spam.yaml')
    config_yaml = File.expand_path(File.dirname(__FILE__) + '/../config.yaml')
    @env = Rack::MockRequest.env_for '/comments', YAML.load_file(env_yaml)
    @spam = Rack::MockRequest.env_for '/comments', YAML.load_file(spam_yaml)
    @domain = 'http://copypastel.com'
    @key = YAML.load_file(config_yaml)[:akismet]
    @post_url = '/comments'
  end

  it 'should instantiate with a domain name, api key and post url' do
    lambda { Akismet.new(@domain, @key, @post_url) }.should_not raise_error
  end
  
  before(:all) { @akismet_filter = Akismet.new(@domain, @key, @post_url) }

  it 'should be able to verify credentials' do
    @akismet_filter.verify?.should be_true
  end

  it 'should detect spam' do
    @akismet_filter.spam?(@spam).should be_true
    @akismet_filter.spam?(@env).should be_false
  end

end