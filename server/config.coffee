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
