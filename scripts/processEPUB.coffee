fs = require 'fs'
path = require 'path'
EPub = require 'epub'
cheerio = require 'cheerio'
async = require 'async'

setupDB = require '../server/database'
Book = require '../server/models/Book'
Chapter = require '../server/models/Chapter'
Paragraph = require '../server/models/Paragraph'

# TODO next time use friggin promises

fileNames = process.argv[2...]
if fileNames.length > 0
  setupDB ->

    bookInserters = fileNames.map (fileName) ->
      epub = new EPub fileName

      (bookCallback) ->
        epub.on 'end', ->
          book =
            title: epub.metadata.title
            author: epub.metadata.creator
            date: epub.metadata.date
            ISBN: epub.metadata.ISBN

          console.log "Starting on #{book.title}"

          Book.findOneAndUpdate {title: book.title}, book, {upsert: yes, new: yes}, (err, book) ->
            throw err if err
            console.log "Saved #{book.get 'title'}"
            # Create chapter inserting functions
            chapterInserters = epub.flow.map (chapter) ->
              epubChapterId = chapter.id
              chapter =
                title: chapter.title
                order: chapter.order
                book: book.get 'title'

              return unless chapter.title and chapter.order

              (chapterCallback) ->
                Chapter.findOneAndUpdate {book: chapter.book, order: chapter.order}, chapter, {upsert: yes, new: yes}, (err, chapter) ->
                  epub.getChapterRaw epubChapterId, (err, text) ->
                    $ = cheerio.load text

                    # Create paragraph inserting functions
                    paragraphInserters = $('p').map (i, p) ->
                      paragraph =
                        text: $(p).text()
                        chapter: chapter.id
                        book: book.id
                        order: i

                      if isUsableParagraph paragraph.text
                        (pCallback) -> Paragraph.findOneAndUpdate {chapter: paragraph.chapter, order: paragraph.order}, paragraph, {upsert: yes, new: yes}, pCallback

                    if paragraphInserters.length > 0
                      # when all paragraphs inserted for a chapter, callback chapter
                      async.parallel paragraphInserters.get(), chapterCallback
                    else
                      console.log "Exluding chapter #{chapter.get 'title'} from #{book.get 'title'}"
                      chapter.remove chapterCallback

            chapterInserters = chapterInserters.filter (el) -> el
            # When all chapters finished, callback book
            async.parallel chapterInserters, (err) ->
              throw err if err
              console.log "Finished all #{chapterInserters.length} chapters for #{book.get 'title'}"
              bookCallback arguments...

        epub.parse()

    async.parallel bookInserters, (err, results) ->
      throw err if err
      console.log "Finished inserting all books"
      process.exit()

isUsableParagraph = (p) ->
  p.split(' ').length > 4
