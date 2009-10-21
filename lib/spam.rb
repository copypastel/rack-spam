class StringIO
  def append( string )
    current = self.pos
    self.pos = self.length
    self << string
    self.pos = current
    self
  end
end

module Rack
  class Spam
    
    class NoFilterSet < Exception; end
    
    attr_reader :filters
    
    # Add a Filter to the list to check environments against
    
    def initialize( app, opts = {} )
      @app = app
      @filters = []
      @block = opts[:block]
      domain = opts[:domain]
      post_url = opts[:post_url]
      if services = opts[:services]
        services.each_pair {|serv, key| add_filter(serv, domain, key, post_url)} 
      end
    end
    
    def call( env )
      @app.call(env) unless comment?(env)
      request = Request.new env
      if spam? env
        if block_msgs?
          names = filters.map {|f| f.service}
          body = "Sorry, your comment was considered spam by <b>#{names.join(' ')}</b>. Try again with something less spammy!"
          return [200, {}, "<center><b>#{body}</b></center>"]
        else
          env['rack.input'].append '&spam=1'
        end
      end
      @app.call(env)
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
    
    private
    
    # Checks if a request is a comment. Necessary before the request is checked for spam.
    
    def comment?( env )
      return false unless env['REQUEST_METHOD'] == 'POST' and 
                          env['PATH_INFO'] =~ /#{@post_url}/
      request = Request.new env
      [ :username, :email, :comment ].all? { |key| not request[key].nil?  }
    end
    
    def block_msgs?
      @block
    end
  end
end