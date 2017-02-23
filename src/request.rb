require 'discordrb'
require 'yaml'
require './bot.rb'

#messy implementation, involves storing threads
module Request
  extend Discordrb::Commands::CommandContainer
  
  #Initialisation of parameters
  CONFIG = YAML.load_file('../config/request.yaml')
  PERMS = YAML.load_file('../config/permissions.yaml')

  DEFAULT_WAITTIME = CONFIG['default_wait']; MIN = CONFIG['min_wait']; MAX = CONFIG['max_wait']
  
  hire_bots = []

  for rbt in CONFIG['bots']
    hire_bots << Bot.new(rbt['id'],rbt['cid'],rbt['token'])
  end

  bots_in_use = []

  ADMIN_ROLES = PERMS['admins']
  REQUEST_ROLES = PERMS['requests']
  #Request a bot for a time, takes one from the pool, assigns it and nicknames
  #it, then sets a timer to undo this action in a thread and stores it in the
  #use pool
  command :request do |event, time=DEFAULT_WAITTIME.to_i|
    if ((event.user.roles.map {|x| x.id} & REQUEST_ROLES).length != 0)
      if time.to_i > MAX.to_i or time.to_i < MIN.to_i
        time = 30
      end
      
      if hire_bots.any?
        choice = hire_bots.shift
        choice.assign_user(event.user.id)
      else
        event.respond "Sorry, no test bots available right now."
        return
      end
      
      event.server.member(choice.cid).nick = "+Test#{choice.id}-"+event.user.name
      
      event.user.pm(choice.message)
      
      t = Thread.new {
        sleep(time.minutes);
        event.server.member(choice.cid).nick = "+Test#{choice.id}"
        for i in 0..(bots_in_use.length)
          if bots_in_use[i].id == choice.id
            hire_bots << bots_in_use.delete_at(i)
          end
        end
      }
      
      choice.store_thread(t)
      
      bots_in_use << choice
    end
    return
  end
  
  #given an id, searches the in use pool for the user id and then renames it,
  #kills the thread and then moves the bot back into the request pool
  command :relinquish do |event, num|
    for i in 0..(bots_in_use.length)
      if bots_in_use[i] and bots_in_use[i].id == num.to_i and (bots_in_use[i].user == event.user.id or (event.user.roles.map {|x| x.id} & ADMIN_ROLES).length != 0)
          choice = bots_in_use.delete_at(i)
          event.server.member(choice.cid).nick = "+Test#{choice.id}"
          choice.kill_thread
          hire_bots << choice
      end
    end
    return
  end

end
