require 'discordrb'
require './request'

bot = Discordrb::Commands::CommandBot.new token: 'MjgzOTQzOTQ4NjM5MTQxODg4.C49J-Q.OwchZTJGMXtzlc8E1kyFjFygkFQ', client_id: '283943948639141888', prefix: '!', advanced_functionality: true

bot.include! Request
bot.run
