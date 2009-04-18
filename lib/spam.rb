module Rack
  module Spam
    
    class NoFilterSet < Exception; end
    
    @@filters = []
    
    # Add a Filter to the list to check environments against
    
    def self.add_filter(service, domain, key, post_url)
      @@filters << Filter.build( service, domain, key, post_url )
    end
    
    # Checks a request environment against all registered Filters
    
    def self.spam?( env )
      raise NoFilterSet if @@filters.empty?
      result = true
      @@filters.each {|filter| result &&= filter.spam?(env) }
      return result
    end
    
    def self.filters
      @@filters
    end
    
  end
end