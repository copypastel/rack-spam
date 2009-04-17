module Rack
  module Spam
    class Filter
      
      attr_accessor :service, :domain, :key, :post_url
      
      @@services = [:akismet, :defensio, :mollom]
      
      def initialize(service, domain, key, post_url)
        raise InvalidArgument unless @@services.include? service
        @service, @domain, @key, @post_url = service, domain, key, post_url
      end
      
      def spam?( env )
        true
      end

      def comment?( env )
        return false unless env['REQUEST_METHOD'] == 'POST'
        return false unless env['PATH_INFO'] =~ Regexp.new('.*' + @post_url)
        input = env['rack.input'].read
        [/&?username=/, /&?email=/, /&?comment=/].each do |attribute|
          return false unless input =~ attribute
        end
        true
      end
      
    end
  end
end