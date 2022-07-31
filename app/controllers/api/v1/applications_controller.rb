class Api::V1::ApplicationsController < ApplicationController

    ALLOWED_DATA = %[name].freeze

    def index
        apps = Application.all
        result = []
        apps.each do |a|
            result.push(a.slice(:token, :name, :chat_count))
        end

        if result.length()>0
            render json: result
        else
            render json: {"error": "No Applications Found"}
        end
    end

    def show
        app = Application.find_by(token: params[:id])
        if app
            render json: app.slice(:token, :name, :chat_count)
        else
            render json: {"error": "Application Not Found"}
        end
    end

    def create

        data = json_payload.select {|d| ALLOWED_DATA.include?(d)}        
        
        app = Application.find_by(name: data[:name])
        if app
            render json: {"error": "Application Already Exists"}
            return
        end
        loop do
            @token = SecureRandom.hex(10)

            break @token unless Application.where(token: @token).exists?
        end
        data[:token] = @token + "_" + data[:name]
        data[:chat_count] = 0.to_i
        data[:function] = "createApp"


        Producer.send(data.to_json)

        data[:status] = "Application Created Successfully"

        render json: data.slice(:status, :token, :name)

        
    end

    def update
        app = Application.find_by(token: params[:id])
        if app
            data = json_payload.select {|d| ALLOWED_DATA.include?(d)}     

            data.each do |key, value|
                app[key] = value
            end
            app.save
            render json: app.slice(:token, :name, :chat_count)
        else
            render json: {"error": "Application Not Found"}
        end
    end

end
