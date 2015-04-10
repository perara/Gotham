'use strict'

Database = require '../Database/Database.coffee'

Filesystem = require '../Objects/Filesystem.coffee'

await = require('asyncawait/await');


exports.RelationMapping =
"""
  setUp: (callback) ->
    @db = new Database()
    callback()


  'Filesystem Mapping': (test) ->
   model = @db.Model()

    model.Filesystem.find(1).then((str) ->

      filesystem = new Filesystem()
      filesystem.Parse(str.data)
      return filesystem

    ).then (filesystem) ->

      console.log filesystem.Get()
    """
























