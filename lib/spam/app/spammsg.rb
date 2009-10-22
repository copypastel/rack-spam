require 'sequel'

module Rack::Spam
  class App
    @@Ss ||= Sequel.connect('sqlite://spam.db')

    @@Ss.create_table :spam_msgs do
      primary_key :id
      String      :username
      String      :email
      Text        :comment
      Datetime    :date
    end unless @@Ss.table_exists?( :spam_msgs )

    class SpamMsg < Sequel::Model(@@Ss[:spam_msgs])

      def to_date
        self.date.strftime "%d.%m.%y"
      end

      def to_time
        self.date.strftime "%H:%M"
      end
      
    end
    
  end
end