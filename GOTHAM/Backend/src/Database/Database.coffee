Sequelize = require('Sequelize')
fs =  require 'fs'
log = require('log4js').getLogger("Database")


User = require './Models/User.coffee'





class Database



  constructor: (host, username, password)->
    @_models = {}
    @Model = @_models

    @InitSequelize()
    LoadModels(@)

  InitSequelize: ->
    log.info "Establishing database connection..."
    @_sequelize = new Sequelize('gotham', 'root', '%123zombies%', {
      host: 'hybel.keel.no'
      dialect: 'mysql'

      pool:
        max: 5
        min: 0
        idle: 10000
    })

  AddModel: (name, model) ->
    log.info "[MODEL] Added #{name} --> #{model.name}"
    if not @_models then @_models = {}
    @_models[name] = model

  Sequelize: ->
    return @_sequelize

  LoadModels = (that) ->
    fs.readdirSync("#{__dirname}/Models").forEach (file) ->
      if file.match(/.+\.coffee/g) != null and file != "RelationMapping.coffee"
        model = (require './Models/' + file)(that._sequelize, Sequelize)
        that.AddModel file.replace(/\.[^/.]+$/, ""), model

    new(require('./Models/RelationMapping.coffee'))(that.Model)



module.exports = Database



