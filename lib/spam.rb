class Comment
  
  attr_accessor :username, :email, :comment
  
  def spam?
    @spam
  end

end

module Rack
  module Spam
    
    @@filters = {}
    
    def self.add_filter(service, domain, key, post_url)
      @@filters[service.to_sym] = Filter.new( service, domain, key, post_url )
    end
    
    def self.spam?( env )
      results = []
      @@filters.each_value {|filter| results << filter.spam?(env) }
      return results.all? {|r| r == true }
    end
    
  end
end