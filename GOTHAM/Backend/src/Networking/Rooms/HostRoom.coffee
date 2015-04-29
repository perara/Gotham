Room = require './Room.coffee'



###*
# HostRoom, Emitters for Host related events
# @class HostRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class HostRoom extends Room


  define: ->
    that = @

    ###*
    # Emitter for GetHost (Defined as class, but is in reality a method inside HostRoom)
    # @class Emitter_GetHost
    # @submodule Backend.Emitters
    ###
    @addEvent "GetHost", (data) ->
      that.log.info "[HostRoom] GetHost called" + data




module.exports = HostRoom