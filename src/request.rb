require 'discordrb'
require './bot.rb'

#messy implementation, involves storing threads

module Request
  extend Discordrb::Commands::CommandContainer

  #Some Parameters, will be moved
  DEFAULT_WAITTIME = 10

  ADMIN_ID = [284022705496522753,284022811163361281,284022982135906305]

  hire_bots = [Bot.new(1,283922122747936779,'MjgzOTIyMTIyNzQ3OTM2Nzc5.C4-gHg.466NhLjp6oCRlm9CeDOzpCInVl8'), Bot.new(2,283922690207645696,'MjgzOTIyNjkwMjA3NjQ1Njk2.C4-gPw.bkOMI1NOad5lyOryW0ggufwYhjQ')]

  bots_in_use = []

  #Request a bot for a time, takes one from the pool, assigns it and nicknames
  #it, then sets a timer to undo this action in a thread and stores it in the
  #use pool
  command :request do |event, time=DEFAULT_WAITTIME|
    if time.to_i > 30 or time.to_i < 1
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
    
    return
  end

  #given an id, searches the in use pool for the user id and then renames it,
  #kills the thread and then moves the bot back into the request pool
  command :relenquish do |event, id|
    for i in 0..(bots_in_use.length)
      if bots_in_use[i].id == id.to_i
        choice = bots_in_use.delete_at(i)
        event.server.member(choice.cid).nick = "+Test#{choice.id}"
        choice.kill_thread
        hire_bots << choice
      end
    end
    return
  end  
end
