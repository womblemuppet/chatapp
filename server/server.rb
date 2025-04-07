require "sinatra/base"
require "json"

require_relative "database"
require_relative "user_manager"
require_relative "message_manager"

class ChatApp < Sinatra::Base
  before do
    content_type 'application/json'
  end

  configure do
    set :show_exceptions, false
    set :raise_errors, false
  end

  error do
    halt [500, { success: false , message: env['sinatra.error'].message }.to_json]
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
    raise result[:error] unless result[:success] ##

    halt [200, result.to_json]
  end

  post "/authenticate/?" do
    data = JSON.parse(request.body.read, symbolize_names: true)

    user_manager = UserManager.new()
    result = user_manager.authenticate_user(data)
    halt [200, result.to_json]
  end

  get "/messages/?" do
    ## authorisation??
    ## sessions!!??

    message_manager = MessageManager.new()
    result = message_manager.get_messages()

    halt [200, result.to_json]
  end

  post "/messages/?" do
    data = JSON.parse(request.body.read, symbolize_names: true)

    user_manager = UserManager.new()
    user = user_manager.get_user(data[:username])
    if user.nil?
      result = { success: false, error: "User with username #{data[:username]} not found" }
      halt [404, result.to_json]
    end

    message_manager = MessageManager.new()
    result = message_manager.post_message(data)

    halt [200, result.to_json]
  end

end
