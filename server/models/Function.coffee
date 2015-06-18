mongoose = require 'mongoose'
require('mongoose-function')(mongoose)

SystemSchema = new mongoose.Schema {_id: String, value: Function}, {collection: 'system.js'}

module.exports.SystemFunction = mongoose.model 'SystemFunctions', SystemSchema
