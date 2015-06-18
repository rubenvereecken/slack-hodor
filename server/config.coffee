envFile = require('node-env-file')
env = process.env
path = require 'path'


do ->
  envFile path.join '..', '.production' if process.env.NODE_ENV is 'production'

module.exports = config = {}

config.mongo =
  port: env.HODOR_MONGO_PORT or 27017
  host: env.HODOR_MONGO_HOST or 'localhost'
  db: env.HODOR_MONGO_DB or 'hodor'
  username: env.HODOR_MONGO_USERNAME or ''
  password: env.HODOR_MONGO_PASSWORD or ''

config.slack =
  botToken: 'xoxb-6567119056-mcji6LG0g3Kw2gu7xSn87a8O'

config.express =
  port: env.HODOR_EXPRESS_PORT or 5000
