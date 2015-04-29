Loki = require 'lokijs'
fs = require 'fs'
When = require 'when'

###*
# The database class of Gotham Backend, Wraps Sequelize
# @class LocalDatabase
# @constructor
# @required
# @module Backend
# @submodule Backend.LocalDatabase
###
class LocalDatabase


  constructor: ->
    ###*
    # LokiJS Instance
    # @property {GothamObject} db
    # @private
    ###
    @db = new Loki 'loki.json'

    ###*
    # The Model Map
    # @property {GothamObject} Model
    ###
    @Model = {}

    ###*
    # The table map
    # @property {GothamObject} _tables
    # @private
    ###
    @_tables = {}

  ###*
  # retrieves a table from the local database by name
  # @method table
  # @param {String} name
  # @return {LokiJS} The Table
  ###
  table: (name) ->
    if not @_tables[name]
      @_tables[name] = @db.addCollection(name, { indices: ['id'] })
    return @_tables[name]

  ###*
  # Preloads the local database, Sends back a callback
  # @method preload
  # @param {Callback} _c
  ###
  preload: (_c) ->
    that = @
    promises = []

    fs.readdirSync("#{__dirname}/LocalModel").forEach (file) ->
      if file != "GothamObject.coffee"
        fullName = file
        # Remove Extension
        file = file.replace(/\.[^/.]+$/, "")

        promises.push Gotham.Database.Model[file].all().then((objs) ->
          # Require object class
          Object = require "./LocalModel/#{fullName}"

          that.Model[file] = Object

          # Create table
          db_obj = Gotham.LocalDatabase.table(file)
          db_obj.insert new Object(obj) for obj in objs
        ).catch((e)->
          console.log e
        )

    When.all(promises).then () ->
      _c()




module.exports = LocalDatabase
