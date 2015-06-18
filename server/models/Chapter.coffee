mongoose = require 'mongoose'
Book = require './Book'

ChapterSchema = new mongoose.Schema
  title:
    type: String
    required: yes
  order:
    type: Number
  epubId:
    type: String
  book:
    type: String  # Book title
    ref: Book

module.exports = Chapter = mongoose.model 'Chapter', ChapterSchema
