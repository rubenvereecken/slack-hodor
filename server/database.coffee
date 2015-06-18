config = require './config'
mongoose = require 'mongoose'

module.exports = (done) ->
  connectionString = ->
    dbName = config.mongo.db
    address = config.mongo.host + ':' + config.mongo.port
    if config.mongo.username and config.mongo.password
      address = config.mongo.username + ':' + config.mongo.password + '@' + address
    address = "mongodb://#{address}/#{dbName}"

  address = connectionString()
  db = mongoose.connect address

  mongoose.connection.on 'error', (e) -> throw e
  mongoose.connection.once 'open', ->
    console.log "Connection to #{address} successfully established"
    done db if done
