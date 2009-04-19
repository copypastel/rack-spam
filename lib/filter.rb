require File.expand_path(File.dirname(__FILE__) + '/../lib/spam')

class Rack::Spam
  module Filter

    def self.build(service, domain, key, post_url)
      self.const_get(service.to_s.capitalize).new(domain, key, post_url)
    end
    
    def comment?( env )
      return false unless env['REQUEST_METHOD'] == 'POST' and 
                          env['PATH_INFO'] =~ /#{@post_url}/
      request = Request.new env
      [ :username=, :email, :comment ].all? { |key| not request[key].nil?  }
    end

  end
end