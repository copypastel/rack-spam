require 'sinatra/base'

module Rack::Spam
  class App < Sinatra::Base

    require File.expand_path( File.dirname(__FILE__) + '/app/spammsg' )

    set :root, File.dirname(__FILE__) + '/app'
    set :raise_errors, true
    set :static, true
    set :app_file, __FILE__
    set :reload, true
    
    def initialize_copy( from )
      @app = from.app
    end

    get '/__spam__/' do
      @spam_msgs = SpamMsg.all
      @date = Time.now.strftime( "%d@%b'%y" )
      erb :index
    end

  end
end