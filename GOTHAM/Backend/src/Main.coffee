##########################################################
##
## Require Stuff
##
##########################################################
## Third Party
performance = require 'performance-now'
log = require('log4js').getLogger("Main")

# Extensions
require './Tools/JSON.coffee'

# Gotham Party
SocketServer = require './Networking/SocketServer.coffee'
Database = require './Database/Database.coffee'
LocalDatabase = require './Database/LocalDatabase.coffee'
World = require './Objects/World/World.coffee'

#########################################################
##
## Global Scope
##
#########################################################
global.Gotham =
  Database: new Database()
  LocalDatabase: new LocalDatabase()
  World: new World()
  SocketServer: new SocketServer 8081
  Micro: require './Objects/Traffic/Micro/Micro.coffee'
  Util: require './Tools/Util.coffee'

# http://stackoverflow.com/questions/14031763/doing-a-cleanup-action-just-before-node-js-exits
startServer = () ->

  # Start world
  Gotham.World.start()

  server = Gotham.SocketServer
  server.setDatabase(Gotham.Database)
  server.registerRoom new (require './Networking/Rooms/HostRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/UserRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/WorldMapRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/GeneralRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/MissionRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/Applications/TracerouteRoom.coffee')()
  server.registerRoom new (require './Networking/Rooms/Applications/PingRoom.coffee')()
  server.start()

  server.onConnect = (_client) ->
    log.info "[SERVER] Client Connected #{_client.id}"
  server.onDisconnect = (_client) ->
    log.info "[SERVER] Client Disconnected #{_client.id}"

preload = (_c) ->

  start = performance()
  Gotham.LocalDatabase.preload ->
    log.info "Preload done in #{((performance() - start) / 1000).toFixed(2)} Seconds"
    _c()





# Preload then start server
preload ->
  startServer()

  testSession()


testSession = ->

  db_node = Gotham.LocalDatabase.table("Node")
  db_network = Gotham.LocalDatabase.table("Network")
  db_host = Gotham.LocalDatabase.table("Host")

  sourceHost = db_host.findOne(id: 2)
  targetNetwork = db_network.findOne(id: 1598)

  nodes = []

  nodes.push(db_node.findOne(id: 50))
  nodes.push(db_node.findOne(id: 51))
  nodes.push(db_node.findOne(id: 52))

  # Make layers
  #ls = new Gotham.Micro.LayerStructure().makeHTTP()

  #Gotham.Micro.LayerStructure.HTTP()

  packets = []
  packets.push(new Gotham.Micro.Packet("Hello", true))
  packets.push(new Gotham.Micro.Packet("Hello", true))
  packets.push(new Gotham.Micro.Packet("YEs dog", false))


  # Get nodes for source and target
  sourceNode = sourceHost.getNetwork().getNode()
  targetNode = targetNetwork.getNode()

  # Calculate solution
  solution = Gotham.Micro.Pathfinder.bStar(sourceNode, targetNode, 2, 3)

  # Make session for this traceroute
  ttl = 1
  packets = []
  for i in [0...solution.length]
    sendPacket = new Gotham.Micro.Packet("8", true, ttl)
    returnPacket = new Gotham.Micro.Packet("0", false, ttl)
    packets.push(sendPacket)
    packets.push(returnPacket)
    ttl++

  session = new Gotham.Micro.Session(sourceHost, targetNetwork, "ICMP", packets)
  console.log JSON.stringify(session)


  #console.log sess


MakeMission = (missionID, userID) ->

  getRandomNetwork = ->
    hosts = Gotham.LocalDatabase.table("Host").data
    return hosts[Math.floor(Math.random() * hosts.length)].host

  # Load missions and requirements
  missions = Gotham.LocalDatabase.table("MissionRequirement")
  requirements =  missions.find(mission: missionID)

  # Generate user_mission object
  userMission = {}
  userMission.id = 0
  userMission.mission = missionID
  userMission.user = userID

  commands = {}

  # Get data from requirements and generate base for missions
  for req in requirements

    expected = JSON.parse(req.expected)
    key = expected["key"]
    command = expected["command"]
    propDef = expected["prop"]
    prop = null

    # Connection table in database hopefully remove this
    missionReq = {}
    missionReq.user_mission = userMission
    missionReq.mission_requirement = req.id

    # Check if shit command exists
    if not commands[command] then commands[command] = {}

    # Check if shit key exists in shit command
    if not commands[command][key]

      switch command

      #### If command is network #####
        when "network"
          commands[command][key] = getRandomNetwork()

          if propDef
            prop = Gotham.Util.StringTools.Resolve(commands[command][key], propDef)

      #### If command is none ####
        when "none"
          commands[command][key] = {}

          if propDef
            commands[command][key] = propDef


  console.log commands


  # Get all requirements
  for req in requirements

    emit_value = JSON.parse(req.emit_value)
    emit_input = JSON.parse(req.emit_input)
    expected = JSON.parse(req.expected)

