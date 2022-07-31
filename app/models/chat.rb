class Chat < ApplicationRecord

    def self.setMessageCount
        Chat.find_each do |c|
            c.message_count = $redis.get(c.token+"_"+c.number.to_s)?$redis.get(c.token+"_"+c.number.to_s):0
            c.save
        end
    end
end
