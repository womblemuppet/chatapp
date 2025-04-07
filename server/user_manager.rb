require "active_record"
require "scrypt"

class UserTable < ActiveRecord::Base
  self.table_name = "users"
end

class UserManager
  def get_users
    UserTable.all.map(&:attributes)
  end

  def get_user(username)
    user = UserTable.find_by(username: username)
    return user && user.attributes    
  end

  def create_user(data)
    unless data[:username].present? && data[:password].present?
      raise "Missing necessary data to create new user"
    end

    username = data[:username]
    password = data[:password]
    password_hash = SCrypt::Password.create(password)

    if UserTable.find_by(username: data[:username])
      return { success: false, error: "User #{data[:username]} already exists" }
    end

    new_user = UserTable.create(
      username: username,
      password_hash: password_hash
    )

    return { success: true, result: new_user.attributes }
  end

  def authenticate_user(data)
    unless data[:username].present? && data[:password].present?
      return {
        success: false,
        code: 400,
        error: "Missing necessary data to authenticate user"
      }
    end

    user = UserTable.find_by(username: data[:username])
    return { success: false, code: 401, error: "Failed to authenticate" } unless user

    saved_scrypt_password = SCrypt::Password.new(user[:password_hash])
    password_valid = (saved_scrypt_password == data[:password])

    result = if password_valid
      { 
        success: true,
        code: 200,
        result: { username: data[:username] }
      }
    else
      { success: false, code: 401, error: "Failed to authenticate" }
    end

    return result
  rescue => e
    return { success: false, code: 500, error: e.message }    
  end

end
