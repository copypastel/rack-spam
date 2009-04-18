module Rack::Spam::Filter

  class YourFilter

    def initialize( domain, key, post_url)
      raise NotImplementedError
    end

    # Interface to be implemented by filters
    def spam?( env );     raise NotImplementedError; end
    def comment?( env );  raise NotImplementedError; end
    def verify?;          raise NotImplementedError; end
    def service;          raise NotImplementedError; end

  end
end