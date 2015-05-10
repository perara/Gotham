Room = require './Room.coffee'



###*
# AdministrationRoom, Emitters for administration of game content
# @class AdministrationRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class AdministrationRoom extends Room


  define: ->
    that = @

    ###*
    # Emitter to retrieve Help content
    # @class Emitter_GetHelpContent
    # @submodule Backend.Emitters
    ###
    @addEvent "GetHelpContent", (data) ->
      client = that.getClient @id

      db_help = Gotham.LocalDatabase.table "Help"

      items = db_help.find().filter (i) ->
        if i.parent == null
          return 1
        else
          return 0

      for rootItem in items
        rootItem.getChildren()

      client.Socket.emit 'GetHelpContent', items

    ###*
    # Emitter to update a HelpContent Item
    # @class Emitter_UpdateHelpContent
    # @submodule Backend.Emitters
    ###
    @addEvent "UpdateHelpContent", (data) ->
      client = that.getClient @id

      db_help = Gotham.LocalDatabase.table "Help"


      for id, text of data
        db_help.findOne(id: parseInt(id)).update({
          text: text
        })

      client.Socket.emit 'UpdateHelpContent', "|--> Synchronized with database"














module.exports = AdministrationRoom