require File.expand_path(File.dirname(__FILE__) + '/../lib/spam')

class Rack::Spam
  module Filter

    def self.build(service, domain, key, post_url)
      self.const_get(service.to_s.capitalize).new(domain, key, post_url)
    end

  end
end