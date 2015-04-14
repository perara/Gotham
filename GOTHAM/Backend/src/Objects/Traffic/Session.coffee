Database = require '../../Database/Database.coffee'
Traffic = require './Traffic.coffee'


# Session object containing source, target ,traffic path and packets exchanged
class Session

  constructor: (sourceHost, targetHost, layers) ->

    # Type checks
    if layers not instanceof Traffic.LayerStructure then throw new Error("layers not instance of LayerStructure")
    if sourceHost not instanceof Host then throw new Error("sourceHost not instance of Host")
    if targetHost not instanceof Host then throw new Error("targetHost not instance of Host")

    @path = Pathfinder.TryRandom(sourceHost.Node, targetHost.Node)
    @sourceHost = sourceHost
    @targetHost = targetHost
    @packets = []
    @layers = layers

  toJSON: ->
    if not @layers.IntegrityCheck() then throw new Error("Inconsistent layers")
    return JSON.stringify(this)

  printJSON: -> log.Info(toJSON())

  printLayers: ->

    if not @layers.IntegrityCheck() then log.Error("Integrity check failed")

    log.Info("=========================================")

    log.Info("Link Layer: \t\t" + @layers.L2.type)
    log.Info("Network Layer: \t" + @layers.L3.type)
    log.Info("Transport Layer: \t" + @layers.L4.type)
    log.Info("Encryption Layer: \t" + @layers.L6.type)
    log.Info("Application Layer: \t" + @layers.L7.type)

    log.Info("=========================================")


module.exports = Session