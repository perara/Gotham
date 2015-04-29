Sequelize = require('Sequelize')
fs =  require 'fs'
log = require('log4js').getLogger("Database")
User = require './Models/User.coffee'




###*
# The database class of Gotham Backend, Wraps Sequelize
# @class Database
# @constructor
# @param {String} host
# @param {String} username
# @param {String} password
# @required
# @module Backend
# @submodule Backend.Database
###
class Database



  constructor: (host, username, password)->
    @_models = {}
    ###*
    # The Model Map
    # @property {Sequelize.Model} Model
    ###
    @Model = @_models

    @initSequelize()
    loadModels(@)


  ###*
  # Initializes the Seuqelize connection to the database, when this is done a passive connection is made.
  # @method InitSequelize
  ###
  initSequelize: ->
    log.info "Establishing database connection..."

    ###*
    # The Sequelize Instance
    # @property {Sequelize} sequelize
    ###
    @sequelize = new Sequelize('gotham', 'root', 'root', {
      host: 'localhost'
      dialect: 'mysql'

      pool:
        max: 5
        min: 0
        idle: 10000
    })

  ###*
  # Adds a sequelize model to the database map
  # @method addModel
  ###
  addModel: (name, model) ->
    log.info "[MODEL] Added #{name} --> #{model.name}"
    if not @_models then @_models = {}
    @_models[name] = model


  ###*
  # Loads all models by the specified path
  # @method loadModels
  # @static
  ###
  loadModels = (that) ->
    fs.readdirSync("#{__dirname}/Models").forEach (file) ->
      if file.match(/.+\.coffee/g) != null and file != "RelationMapping.coffee"
        model = (require './Models/' + file)(that.sequelize, Sequelize)
        that.addModel file.replace(/\.[^/.]+$/, ""), model

    new(require('./Models/RelationMapping.coffee'))(that.Model)



module.exports = Database



