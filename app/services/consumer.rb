class Consumer
    
    include Sneakers::Worker
    from_queue 'InstabugQueue'
    
    ALLOWED_APP_DATA = %[token name chat_count].freeze
    ALLOWED_CHAT_DATA = %[token number message_count description].freeze
    ALLOWED_MESSAGE_DATA = %[token chatNumber number body].freeze
    
    def work(msg)
        data = HashWithIndifferentAccess.new(JSON.parse(msg))
        if data[:function]=="createApp"
            appData = data.select {|d| ALLOWED_APP_DATA.include?(d)}
            app = Application.new(appData)
            app.save!
            
            ack!
        elsif  data[:function]=="createChat"
            chatData = data.select {|d| ALLOWED_CHAT_DATA.include?(d)}
            chat = Chat.new(chatData)
            chat.save!
            
            app = Application.find_by(token: data[:token])
            if app
                app.chat_count = app.chat_count + 1
                app.save!
            end
            
            ack!

        elsif  data[:function]=="createMessage"
            messageData = data.select {|d| ALLOWED_MESSAGE_DATA.include?(d)}
            message = Message.new(messageData)
            message.save!

            chat = Chat.find_by(token: data[:token], number: data[:chatNumber])
            if chat
                chat.message_count = chat.message_count + 1
                chat.save!
            end
            
            ack!

        end
    end


end