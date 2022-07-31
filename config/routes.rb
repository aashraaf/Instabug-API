Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :applications, defaults: {format: :json} do
        resources :chats, defaults: {format: :json} do
          post '/search', to: "chats#search", defaults: {format: :json}
          resources :messages, defaults: {format: :json}
        end
      end
    end

  end

end
