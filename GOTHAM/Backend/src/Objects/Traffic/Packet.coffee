class Packet

  constructor: (path) ->

    @consistent = false
    @pathId = Pathfinder.toIdList(path)
    @path = path
    @id

module.exports = Packet