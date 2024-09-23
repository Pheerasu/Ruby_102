class User
  def initialize(name, email, password)
    @name = name
    @email = email
    @password = password
    @rooms = []
  end

  def enter_room(room)
    @rooms << room
    room.users << self
  end

  def send_message(room, content)
    message = Message.new(self, room, content)
    room.broadcast(message)
  end

  def acknowledge_message(room, message)
    @acknowledged_messages ||= {}
    room_messages = @acknowledged_messages[room] ||= {}
    room_messages[message] = true
  end

end

class Room
  def initialize(name, description, users = [])
    @name = name
    @description = description
    @users = users
    @messages = []
  end
  
  def broadcast(message)
    @messages << message
    @users.each { |user| user.acknowledge_message(self, message) }
  end
end

class Message
  def initialize(user, room, content)
    @user = user
    @room = room
    @content = content
  end
end
