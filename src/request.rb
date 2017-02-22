require 'discordrb'

WAITTIME = 10

module Request
  extend Discordrb::Commands::CommandContainer

  command :request do |event, bot|
    if bot.to_i == 1
      event.server.member(283922122747936779).nick = "+Test1-"+event.user.name
      sleep(WAITTIME)
      event.server.member(283922122747936779).nick = "+Test1"
    elsif bot.to_i == 2
      event.server.member(283922690207645696).nick = "+Test2-"+event.user.name
      sleep(WAITTIME)
      event.server.member(283922690207645696).nick = "+Test2"
    else
      event.respond "Unidentified bot selected"
    end
    return
  end

end
