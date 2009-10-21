module Rack::Spam::Filter

  class YourFilter

    include Rack::Spam::Filter

    def initialize( domain, key, post_url)
      raise NotImplementedError
    end

    # Interface to be implemented by filters
    
    # Method to submit an env to the service and check if it's spam
    # Returns true if env is spam, false otherwise
    def spam?( env );     raise NotImplementedError; end
    
    # Method to 'login' to the service. Verifies that the service credentials are valid.
    # Returns true if credentials are valid. Should raise an exception otherwise
    def verify?;          raise NotImplementedError; end
    
    # Should return the service's name as a symbol, i.e. :akismet, :dfensio, :mollom, etc.
    def service;          raise NotImplementedError; end

  end
end