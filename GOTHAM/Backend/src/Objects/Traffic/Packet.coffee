class Packet

  # Layer 2

  ethernet: "Ethernet"
  wifi: "Wifi"

  # Layer 3
  @ICMP =
    name: "IP"
    address: null


  constructor: (path) ->

    @consistent = false
    @pathId = Pathfinder.toIdList(path)
    @path = path
    @id
