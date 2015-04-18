CRG     =     require './country_reverse_geocoding'
Database = require '../Database/Database.coffee'
GeoTool = require '../Tools/GeoTool.coffee'
log = require('log4js').getLogger("ConsistencyFixer")

class ConsistencyFixer

  constructor: ->
    that = @
    db = new Database()
    @Model =  db.Model

    @makeSeaNodes()

  makeSeaNodes: ->
    that = @


    @Model.Cable.all(include: [{model: that.Model.CablePart, include: [that.Model.Cable]}] ).then (cables)->

      # Create array with new locations
      newNodeLocations = []

      # Loop all cable parts
      for cable in cables
        for part in cable.CableParts

          # Determine country
          output = CRG.country_reverse_geocoding().get_country(part.lat, part.lng)

          # If in a country, create a location entry
          if output != null
            newNodeLocations.push(
              lat: part.lat
              lng: part.lng
              cableId: cable.id
            )
            log.info output
      log.info "Nodes found: #{newNodeLocations.length}"


      that.processLocation(newNodeLocations)



  processLocation: (newNodeLocations) ->
    that = @
    for nodeLoc in newNodeLocations

      that.Model.Location.all(
        where:
          lat:
            gte: nodeLoc.lat - 1
            lte: nodeLoc.lat + 1
          lng:
            gte: nodeLoc.lng - 1
            lte: nodeLoc.lng + 1
      ).then (closeNodes) ->
        closest = GeoTool.getClosest(nodeLoc, closeNodes)
        closest.cableId = nodeLoc.cableId
        if not closest
          log.info "Could not find location for node"
        else
          that.addNode(closest)


  # Takes  cable. Makes the node and connects it to the cable.
  addNode: (node) ->

    # Generates and writes the node to the database
    @Model.Node.create(
      name: node.name
      countryCode: node.countryCode
      tier:
        id: 4
      lat: node.lat
      lng: node.lng
      bandwidth: 0
      priority: 0
    )
    .then (db_node) ->
      log.info "Added node: #{db_node.id}"


    # Makes the node_cable connection
    @Model.NodeCable.create(
      node: node.id
      cable: node.cableId
    ).then (nodeCable) ->
      log.info "Connected node #{node.id} to cable #{node.cable.id}"


module.exports = ConsistencyFixer
