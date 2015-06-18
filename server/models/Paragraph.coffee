mongoose = require 'mongoose'
Book = require './Book'
Chapter = require './Chapter'

ParagraphSchema = new mongoose.Schema
  text: type: String
  order: type: Number
  chapter:
    type: mongoose.Schema.ObjectId
    ref: Chapter
  book:
    type: mongoose.Schema.ObjectId
    ref: Book


module.exports = Paragraph = mongoose.model 'Paragraph', ParagraphSchema
