class Api::V1::MessagesController < ApplicationController
    ALLOWED_DATA = %[ body ].freeze

    def index
        messages = Message.where("token = :token AND chatNumber = :chatNumber", {token: params[:application_id], chatNumber: params[:chat_id]})
        
        result = []
        messages.each do |m|
            result.push(m.slice(:token, :chatNumber, :number, :body))
        end

        if result.length()>0
            render json: result
        else
            render json: {"error": "No Messages Found"}
        end
    end

    def show
        message = Message.find_by(token: params[:application_id], chatNumber: params[:chat_id], number: params[:id])
        if message
            render json: message.slice(:token, :chatNumber, :number, :body)
        else
            render json: {"error": "Message Not Found"}
        end
    end

    def create

        data = json_payload.select {|d| ALLOWED_DATA.include?(d)}        
        
        app = Application.find_by(token: params[:application_id])
        if !app
            render json: {"error": "Application Does Not Exists"}
            return
        end

        chat = Chat.find_by(token: params[:application_id], number: params[:chat_id])
        if !chat
            render json: {"error": "Chat Does Not Exists"}
            return
        end

        data[:token] = params[:application_id]
        data[:chatNumber] = params[:chat_id]
        data[:number] = $redis.incr(params[:application_id] + "_" + params[:chat_id]) #increment 1 using redis

        data[:function] = "createMessage"


        Producer.send(data.to_json)

        data[:status] = "Message Created Successfully"

        render json: data.slice(:status, :token, :chatNumber, :number, :body)

        
    end

    def update
        message = Message.find_by(token: params[:application_id], chatNumber: params[:chat_id], number: params[:id])
        if message
            data = json_payload.select {|d| ALLOWED_DATA.include?(d)}     

            data.each do |key, value|
                message[key] = value
            end
            message.save
            render json: message.slice(:token, :chatNumber, :number, :body)
        else
            render json: {"error": "Message Not Found"}
        end
    end
end
