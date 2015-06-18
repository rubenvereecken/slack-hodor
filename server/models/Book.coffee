mongoose = require 'mongoose'

BookSchema = new mongoose.Schema
  title:
    type: String
    required: yes
    unique: yes
  author:
    type: String
  ISBN:
    type: String


module.exports = Book = mongoose.model 'Book', BookSchema
