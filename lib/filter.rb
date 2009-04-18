require File.expand_path(File.dirname(__FILE__) + '/../gem/rdefensio/lib/rdefensio')
require File.expand_path(File.dirname(__FILE__) + '/../gem/ruby-mollom/lib/mollom')

module Rack
  module Spam
    module Filter
      
      attr_reader :domain, :key, :post_url
      
      def self.build(service, domain, key, post_url)
        self.const_get(service.to_s.capitalize).new(domain, key, post_url)
      end
       
    end
  end
end