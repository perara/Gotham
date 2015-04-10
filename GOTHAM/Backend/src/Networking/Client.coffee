


class Client

  class Permission
    Map = 1
    Login = null
    Logout = null
    Filesystem = 2


  @Permission = Permission



  constructor: (ioclient) ->
    # Socet.IO Client Object
    @Socket = @_ioclient = ioclient
    @id = @_ioclient.id


    @_permissions = []
    @_authenticated = false
    @_auth_level = []
    @_user = null



  Authenticate: () ->
    @_authenticated = true


  IsAuthenticated: ->
    return @_authenticated

  GetAuthenticationLevel: ->
    return @_auth_level


  GetPermission: ->
    return @_permissions

  HasPermission: (permission) ->
    if permission in @_permissions
      return true
    return false

  SetUser: (user) ->
    @_user = user
    return @_user
  GetUser: ->
    return @_user









module.exports = Client