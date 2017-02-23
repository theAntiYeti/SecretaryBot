require 'discordrb'
require 'yaml'
require './request'

CONFIG = YAML.load_file('../config/connection.yaml')
bot = Discordrb::Commands::CommandBot.new token: CONFIG['robot_token'], client_id: CONFIG['robot_cid'], prefix: '!', advanced_functionality: true


bot.include! Request
bot.run
