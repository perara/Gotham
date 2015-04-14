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
    @model.Node.all().then (nodes)->
      _solution = Traffic.Pathfinder.tryRandom(nodes[5], nodes[200])
      log.info(_solution)

    done()


































