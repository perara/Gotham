
# Session object containing source, target ,traffic path and packets exchanged
class Session

  constructor: (sourceHost, targetHost, layers) ->

    @path = Gotham.Micro.Pathfinder.TryRandom(sourceHost.Node, targetHost.Node)
    @sourceHost = sourceHost
    @targetHost = targetHost
    @packets = []
    @layers = layers

  printJSON: ->
    if not @layers.IntegrityCheck() then throw new Error("Inconsistent layers")
    log.Info(JSON.stringify(this))

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