class Application < ApplicationRecord

    def self.setChatCount
        Application.find_each do |app|
            app.chat_count = $redis.get(app.token)?$redis.get(app.token):0
            app.save
        end
    end
end
