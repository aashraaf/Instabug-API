class Api::V1::ChatsController < ApplicationController

    ALLOWED_DATA = %[ description ].freeze

    def search
        data = json_payload
        messages = Message.search(data[:query], params[:application_id], params[:chat_id])

        if messages.length()>0
            render json: messages
        else
            render json: {"error": "No Results Found"}
        end

    end

    def index
        chats = Chat.where("token = ?", params[:application_id])
        
        result = []
        chats.each do |c|
            result.push(c.slice(:token, :number, :description, :message_count))
        end

        if result.length()>0
            render json: result
        else
            render json: {"error": "No Chats Found"}
        end
    end

    def show
        chat = Chat.find_by(token: params[:application_id], number: params[:id])
        if chat
            render json: chat.slice(:token, :number, :description, :message_count)
        else
            render json: {"error": "Chat Not Found"}
        end
    end

    def create

        data = json_payload.select {|d| ALLOWED_DATA.include?(d)}        
        
        app = Application.find_by(token: params[:application_id])
        if !app
            render json: {"error": "Application Does Not Exists"}
            return
        end

        data[:token] = params[:application_id]
        data[:number] = $redis.incr(params[:application_id]) #increment 1 using redis

        data[:message_count] = 0
        data[:function] = "createChat"


        Producer.send(data.to_json)
       
        data[:status] = "Chat Created Successfully"

        render json: data.slice(:status, :token, :number, :description, :message_count)

        
    end

    def update
        chat = Chat.find_by(token: params[:application_id], number: params[:id])
        if chat
            data = json_payload.select {|d| ALLOWED_DATA.include?(d)}     

            data.each do |key, value|
                chat[key] = value
            end
            chat.save
            render json: chat.slice(:token, :number, :description, :message_count)
        else
            render json: {"error": "Chat Not Found"}
        end
    end
end
