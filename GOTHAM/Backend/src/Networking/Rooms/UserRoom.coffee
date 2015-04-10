Room = require './Room.coffee'




class UserRoom extends Room

  define: ->

    @AddEvent "i am god", (data) ->
      # @ = client object
      console.log "Yes i am god pls"









module.exports = UserRoom



