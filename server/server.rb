require "sinatra/base"
require "json"

require_relative "database"
require_relative "user_manager"

class ChatApp < Sinatra::Base
  before do
    content_type 'application/json'
  end

  get "/" do
    "Chat App running here!"
  end

  get "/users/?" do
    user_manager = UserManager.new()
    users = user_manager.get_users()

    result = {
      result: users
    }
    
    halt [200, result.to_json]
  end

  post "/users/?" do
    data = JSON.parse(request.body.read, symbolize_names: true)

    user_manager = UserManager.new()
    result = user_manager.create_user(data)
    raise result[:error] unless result[:success]

    halt [200, result.to_json]
  rescue => e
    result = {
      success: false,
      error: "Error: #{[e.message, *e.backtrace[0..10]].join("\n")}"
    }

    halt [500, result.to_json]
  end

  post "/authenticate/?" do
    data = JSON.parse(request.body.read, symbolize_names: true)

    user_manager = UserManager.new()
    result = user_manager.authenticate_user(data)
    if result[:success]
      halt [200, result.to_json]
    else
      halt [200, result.to_json]
    end
    
  rescue => e
    halt [500, "Error: #{[e.message, *e.backtrace[0..10]].join("\n")}"]
  end

end
