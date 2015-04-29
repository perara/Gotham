GothamObject = require './GothamObject.coffee'


###*
# Host Model, A host object. This is basically a Computer
# @class Host
# @constructor
# @param {Sequelize.Model} model
# @required
# @extends GothamObject
# @submodule Backend.LocalDatabase
###
class Host extends GothamObject

  constructor: (model) ->
    super(model)


  ###*
  # Get filesystem associated with this host
  # @method getFilesystem
  # @return {Filesystem}
  ###
  getFilesystem: ->
    if not @Filesystem
      db_filesystem = Gotham.LocalDatabase.table("Filesystem")
      @Filesystem = db_filesystem.findOne({id: @filesystem})
    return @Filesystem

  ###*
  # Get the associated network for this host
  # @method getNetwork
  # @return {Network}
  ###
  getNetwork: ->
    if not @Network
      db_network = Gotham.LocalDatabase.table("Network")
      @Network = db_network.findOne({id: @network})
    return @Network

###*
# The identifier for this host
# @property {Integer} id
###
###*
# The machine name for this host
# @property {String} machine_name
###
###*
# Online state On off state
# @property {Boolean} online
###
###*
# The ipv4 for this host
# @property {String} ip
###
###*
# The mac address for the host
# @property {String} mac
###
###*
# filesystem (id) for the host
# @property {Integer} filesystem
###
###*
# network (id) for the host
# @property {Integer} network
###






module.exports = Host