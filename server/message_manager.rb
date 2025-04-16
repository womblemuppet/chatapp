require "active_record"

class MessagesTable < ActiveRecord::Base
  self.table_name = "messages"
end

class MessageManager
  def get_messages
    ## infinite scroll?
    
    last_20_messages = MessagesTable
      .all
      .limit(200)
      .order(time_sent: "DESC")
      .map(&:attributes)

    return { success: true, messages: last_20_messages }
  end

  def post_message(message_data)
    new_message = MessagesTable.new(
      username: message_data[:username],
      text: message_data[:text],
      time_sent: Time.now()
    )

    new_message.save!

    return { success: true, message: new_message.attributes }
  end

end
