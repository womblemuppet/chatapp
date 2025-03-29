require "active_record"
require "mysql2"

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  host: ENV["MYSQL_HOST"],
  port: 3306,
  username: 'mysql_user',
  password: "password",
  database: "chatapp_main_db"
)
