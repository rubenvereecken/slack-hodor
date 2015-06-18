setupDB = require '../server/database'
Book = require '../server/models/Book'
Chapter = require '../server/models/Chapter'
Paragraph = require '../server/models/Paragraph'
Word = require '../server/models/Word'

natural = require 'natural'
mongoose = require 'mongoose'
async = require 'async'
_ = require 'lodash'

# Mapreduce approach didn't work. It's really hard to ram functions into mongo. So client sided :(

setupDB ->
  q = Paragraph.find {}
  #q.limit(20)
  q.exec (err, paragraphs) ->
    throw err if err
    console.log "Processing #{paragraphs.length} paragraphs"
    words = {}

    paragraphs.forEach (paragraph) ->
      stemmedParagraph = natural.PorterStemmer.tokenizeAndStem paragraph.get 'text'
      stemmedParagraph.forEach (stemmed) ->
        return unless countsAsWord stemmed
        words[stemmed] = word: stemmed, occurrences: [] unless stemmed of words
        words[stemmed].occurrences.push paragraph.id

    console.log "Finished #{paragraphs.length} paragraphs"

    wordSavers = Object.keys(words).map (word) ->
      wordDoc = words[word]
      wordDoc.occurrences = _.uniq wordDoc.occurrences
      (wordCallback) -> Word.findOneAndUpdate {word: word}, wordDoc, {upsert: yes, new: yes}, wordCallback

    async.parallel wordSavers, (err, results) ->
      throw err if err
      console.log "Finished #{results.length} words"
      process.exit()

countsAsWord = (word) ->
  yes
