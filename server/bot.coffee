slackAPI = require 'slackbotapi'
config = require './config'

module.exports = ->
  slack = new slackAPI
    token: config.slack.botToken
    logging: yes



  slack.on 'message', (data)->
    return unless data.text



    if data.text.match /.*hodor.*/
      slack.sendMsg data.channel, 'hodor'
