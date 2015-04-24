Loki = require 'lokijs'

class LocalDatabase


  constructor: ->
    @db = new Loki 'loki.json'
    @_tables = {}

  table: (name) ->
    if not @_tables[name]
      @_tables[name] = @db.addCollection(name, { indices: ['id'] })
    return @_tables[name]


module.exports = LocalDatabase
