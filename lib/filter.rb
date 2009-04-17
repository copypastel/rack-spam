require File.expand_path(File.dirname(__FILE__) + '/../gem/akismet/lib/akismet')
require File.expand_path(File.dirname(__FILE__) + '/../gem/rdefensio/lib/rdefensio')
require File.expand_path(File.dirname(__FILE__) + '/../gem/ruby-mollom/lib/mollom')

module Rack
  module Spam
    class Filter
      
      attr_reader :domain, :key, :post_url
      
      class Service < Struct.new(:name, :instance); end;
      
      @@services = [:akismet, :defensio, :mollom]
      
      def initialize(service, domain, key, post_url)
        raise InvalidArgument unless @@services.include? service
        @domain, @key, @post_url = domain, key, post_url
        case service
          when :akismet: @service = Service.new(service, Akismet.new(key, domain))
          when :defensio:
          when :mollom:
        end
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
      
      def verify?
        @service.instance.verify?
      end
      
      def service
        @service.name
      end
      
    end
  end
end