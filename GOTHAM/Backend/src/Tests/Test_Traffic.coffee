'use strict'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
expect = chai.expect
log = require('log4js').getLogger("Test_Traffic")

Traffic = require '../Objects/Traffic/Micro/Micro.coffee'
Database = require '../Database/Database.coffee'


suite 'Networking Tests', ->
  suiteSetup ->

    @model = new Database().Model

  suiteTeardown ->

  test 'LayerStructure OK', (done)->

    ls = new Traffic.LayerStructure()
    ls.ethernet()
    ls.integrityCheck()

    done()


  test 'Pathfinding OK', (done)->
    this.timeout = 20000

    @model.Node.all(
      include: [
        {
          model: @model.Cable
          include: [@model.Node]
        }
      ]
    ).then (nodes)->

      solution = Traffic.Pathfinder.bStar(nodes[5], nodes[200])
      Traffic.Pathfinder.printSolution(solution)


      done()



      #_solution = Traffic.Pathfinder.tryRandom(nodes[5], nodes[200])
      #log.info(_solution)




































