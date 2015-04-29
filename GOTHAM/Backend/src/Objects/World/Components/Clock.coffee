moment = require 'moment'

###*
# World Clock, Its a clock...
# @class Clock
# @module Backend
# @submodule Backend.World
###
class Clock

  # Initializes the clock
  constructor: ->
    ###*
    # The moment time object
    # @param {Moment.js} _time
    ###
    @_time = moment() # Set to 'now'


  ###*
  # Start the clock
  # @method start
  ###
  start: ->
    self = this
    setInterval ->
      self.tick()
    , 1000

  ###*
  # tick the clock by a minute
  # @method tick
  ###
  tick: ->
    that = @

    @_time.add(1, 'minutes')

    # Broadcast to clients
    for key, client of Gotham.SocketServer.getClients()
      client.Socket.emit 'World_Clock', that._time.format('D MMM YYYY, H:mm')


  ###*
  # retrieve current calendar time
  # @method getTime
  ###
  getTime: ->
    return @_time.calendar()







module.exports = Clock