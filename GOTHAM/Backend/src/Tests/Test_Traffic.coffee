'use strict'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
expect = chai.expect
log = require('log4js').getLogger("Test_Traffic")

Traffic = require '../Objects/Traffic/Traffic.coffee'
Database = require '../Database/Database.coffee'


suite 'Networking Tests', ->
  suiteSetup ->

    @model = new Database().Model
    @pathfinder = new Traffic.Pathfinder

  suiteTeardown ->


  test 'Pathfinding OK', (done)->
    this.timeout = 20000


    @model.Node.all(
      include: [
        {
          model: @model.Cable
          include: [@model.Node]
        }
      ]
    ).then (node)->

      @node.siblings = []

      for cable in node.Cables
        node.siblings.push cable.Nodes


      """console.log "Name: #{node.name}"
      for cable in node.Cables
        console.log "\tCable: #{cable.name}"
        for cNode in cable.Nodes
          console.log "\t\tNode: #{cNode.name}"""


    @model.Node.find(
      where: id: 15446
      include: [
        {
        model: @model.Cable
        as: 'Cables'
        include: [
          {model: @model.Node, as: 'Nodes'}
        ]
        }
      ]
    ).then (nodes)->

      for node in nodes
        console.log node.id



      done()



      #_solution = Traffic.Pathfinder.tryRandom(nodes[5], nodes[200])
      #log.info(_solution)




































