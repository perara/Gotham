Loki = require 'lokijs'
fs = require 'fs'
When = require 'when'

class LocalDatabase


  constructor: ->
    @db = new Loki 'loki.json'
    @Model = {}
    @_tables = {}

  table: (name) ->
    if not @_tables[name]
      @_tables[name] = @db.addCollection(name, { indices: ['id'] })
    return @_tables[name]

  preload: (_c) ->
    that = @
    promises = []

    fs.readdirSync("#{__dirname}/LocalModel").forEach (file) ->
      if file != "GothamObject.coffee"
        fullName = file
        # Remove Extension
        file = file.replace(/\.[^/.]+$/, "")

        promises.push Gotham.Database.Model[file].all().then (objs) ->
          # Require object class
          Object = require "./LocalModel/#{fullName}"

          that.Model[file] = Object

          # Create table
          db_obj = Gotham.LocalDatabase.table(file)
          db_obj.insert new Object(obj) for obj in objs

    When.all(promises).then () ->
      _c()




module.exports = LocalDatabase
