bodyParser = require 'body-parser'
config = require './config'
webhook = require './webhook'
request = require 'request'

startBot = require './bot'

module.exports = ->
  startBot()
