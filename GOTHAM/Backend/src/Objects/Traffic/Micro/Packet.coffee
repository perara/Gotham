class Packet

  constructor: (path) ->

    @consistent = false
    @pathId = Gotham.Micro.Pathfinder.toIdList(path)
    @path = path
    @id

module.exports = Packet