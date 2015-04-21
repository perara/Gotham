Micro = require './Micro.coffee'

class Connection

  constructor: (host) ->

    @sessions = []
    @host = host

module.exports = Connection