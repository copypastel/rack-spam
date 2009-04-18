require File.expand_path(File.dirname(__FILE__) + '/../../lib/spam')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/filter')
require File.expand_path(File.dirname(__FILE__) + '/../../gem/akismet/lib/akismet')

module Rack::Spam::Filter
  class Akismet < ::Akismet

    include Rack::Spam::Filter

    def initialize(domain, key, post_url)
      @post_url = post_url
      super(key, domain)
    end

    def comment?( env )
      return false unless env['REQUEST_METHOD'] == 'POST' and 
                          env['PATH_INFO'] =~ Regexp.new('.*' + @post_url)
      input = env['rack.input'].read
      [ /&?username=/, 
        /&?email=/, 
        /&?comment=/ ].all? { |attribute| input =~ attribute }
    end

    def verify?
      super
    end

    def spam?( env )
      r = Request.new env
      params = { :user_ip => r.ip, 
                  :user_agent => env['HTTP_USER_AGENT'], 
                  :referrer => r.referrer, 
                  :comment_author => r['username'], 
                  :comment_author_email => r['email'], 
                  :comment_content => r['comment'] }
      super(params)
    end

    def service
      :akismet
    end

  end
end