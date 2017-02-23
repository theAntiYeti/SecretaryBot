#bot.rb
#describes a bot, and who currently uses it
class Bot
  def initialize(id, cid, token)
    @id = id
    @cid = cid
    @token = token
  end

  def message()
    return "\nYou have control of bot #{@id}\ncid: #{@cid}\ntoken: #{@token}"
  end

  def assign_user(user_id)
    @user = user_id
  end

  def store_thread(killthread)
    @thread = killthread
  end

  def kill_thread()
    if @thread.alive?
      @thread.exit
    end
  end

  def clean()
    @thread = nil
    @user = nil
  end
  
  attr_reader :id
  attr_reader :cid
  attr_reader :token
  attr_reader :user
  attr_reader :thread
end
