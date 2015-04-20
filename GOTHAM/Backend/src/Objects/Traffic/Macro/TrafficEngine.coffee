Macro = require './Macro.coffee'
log = require('log4js').getLogger("Traffic_Engine")
LocalDatabase = require '../../../Database/LocalDatabase.coffee'

class TrafficEngine


  constructor: () ->

    that = @
    @nodes = LocalDatabase.table("nodes")

    setInterval (-> that.tick()), 5000


  # Looping function running every minute
  tick: ->

    @updateLoad()


  # Updates all cables and nodes with load depending on local time
  updateLoad: ->

    VARIATION = 5

    # Get the current time
    date = new Date()
    @minutes = (date.getUTCHours() * 60) + date.getUTCMinutes()

    for obj in @nodes.find()
      node = obj.node

      sumCableLoad = 0

      # SUM up cable load
      for cable in node.Cables

        sumCableLoad += cable.updateLoad(@minutes, VARIATION)

      # Set node load
      node.load = sumCableLoad / node.Cables.length

    console.log @nodes.findOne({id: 15522}).node.load

module.exports = TrafficEngine
