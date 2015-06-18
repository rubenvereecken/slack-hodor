mongoose = require 'mongoose'
Paragraph = require './Paragraph'

WordSchema = new mongoose.Schema
  word:
    type: String
    required: yes
    unique: yes
  occurrences:
    type: [mongoose.Schema.ObjectId]
    ref: Paragraph
    default: []

module.exports = Word = mongoose.model 'Word', WordSchema
