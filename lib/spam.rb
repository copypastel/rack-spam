module Rack
  class Spam
    
    class NoFilterSet < Exception; end
    
    attr_reader :filters
    
    # Add a Filter to the list to check environments against
    
    def initialize( app, opts = {} )
      @app = app
      @filters = []
    end
    
    def call( env )
      request = Request.new env
      if spam? env
        # what to do here?
      else
        return @app.call(env)
      end
    end
    
    def add_filter(service, domain, key, post_url)
      @filters << Filter.build( service, domain, key, post_url )
    end
    
    # Checks a request environment against all registered Filters
    
    def spam?( env )
      raise NoFilterSet if @filters.empty?
      result = true
      @filters.each {|filter| result &&= filter.spam?(env) }
      return result
    end
    
    def self.filters
      @@filters
    end
    
  end
end