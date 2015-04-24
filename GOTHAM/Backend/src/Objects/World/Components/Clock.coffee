moment = require 'moment'


class Clock

  # Initializes the clock
  constructor: ->
    @_time = moment() # Set to 'now'



  Start: ->
    self = this
    setInterval ->
      self.Tick()
    , 1000

  # Tick the clock by a minute
  Tick: ->
    that = @

    @_time.add(1, 'minutes')

    # Broadcast to clients
    for key, client of Gotham.SocketServer.GetClients()
      client.Socket.emit 'World_Clock', that._time.format('D MMM YYYY, H:mm')



  GetTime: ->
    return @_time.calendar()







module.exports = Clock