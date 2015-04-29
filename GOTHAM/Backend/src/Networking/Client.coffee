###*
# The Client object which is created whenever a User connects to the websocket server
# @class Client
# @constructor
# @param {Socket.IO.Client} ioclient
# @required
# @module Backend
# @submodule Backend.Networking
###
class Client

  ###*
  # Dictionary over permission flags
  # @property {Object} Permission
  # @static
  ###
  @Permission =
    Map: 1
    Login: null
    Logout: null
    Filesystem: 2



  constructor: (ioclient) ->

    ###*
    # The SocketIO client object
    # @property {Socket.IO.Client} Socket
    ###
    @Socket = @_ioclient = ioclient

    ###*
    # The Identification from the Socket.IO connection
    # @property {Hash} id
    ###
    @id = @_ioclient.id

    ###*
    # Permission Array
    # @property {Array} _permissions
    ###
    @_permissions = []

    ###*
    # Flag to determine if user is authenticated
    # @property {Boolean} _authenticated
    ###
    @_authenticated = false

    ###*
    # Array of flags to determine auth level of the client
    # @property {Array} _auth_level
    ###
    @_auth_level = []

    ###*
    # User object (User)
    # @property {User} _user
    ###
    @_user = null


  ###*
  # Authenticate the client
  # @method authenticate
  ###
  authenticate: () ->
    @_authenticated = true

  ###*
  # Checks if the user is authenticated
  # @method isAuthenticated
  ###
  isAuthenticated: ->
    return @_authenticated

  ###*
  # Retrieves Authentication level
  # @method getAuthenticationLevel
  # @return {Array} _auth_level
  ###
  getAuthenticationLevel: ->
    return @_auth_level


  ###*
  # Retrieve the permission list
  # @method getPermission
  # @return {Array} _permission
  ###
  getPermission: ->
    return @_permissions

  ###*
  # Checks weither the user has permission which is inputed
  # @param {Permission} permission
  # @method hasPermission
  # @return {Boolean}
  ###
  hasPermission: (permission) ->
    if permission in @_permissions
      return true
    return false

  ###*
  # Sets the user object
  # @param {User} user
  # @method setUser
  # @return {User}
  ###
  setUser: (user) ->
    @_user = user
    return @_user

  ###*
  # Retrieves the user object
  # @method getUser
  # @return {User}
  ###
  getUser: ->
    return @_user









module.exports = Client