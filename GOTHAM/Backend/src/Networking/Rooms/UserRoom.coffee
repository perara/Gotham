Room = require './Room.coffee'

###*
# UserRoom, Room which contains emitter related to user events
# @class UserRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class UserRoom extends Room

  define: ->
    that = @


    ###*
    # Emitter for getting a user (Defined as class, but is in reality a method inside UserRoom)
    # @class Emitter_GetUser
    # @submodule Backend.Emitters
    ###
    @addEvent "GetUser", (data) ->
      client = that.getClient(@id)

      db_user = Gotham.LocalDatabase.table("User")
      user = db_user.findOne({id: client.getUser().id})

      client.Socket.emit 'GetUser', {
        id: user.id
        email: user.email
        experience: user.experience
        money: user.money
        username: user.username
        Identities: user.getIdentities().map (identity) ->
          return {
            active: identity.active
            address: identity.address
            birthday: identity.birthday
            city: identity.city
            company: identity.company
            country: identity.country
            email: identity.email
            first_name: identity.first_name
            fk_user: identity.fk_user
            id: identity.id
            last_name: identity.last_name
            lat: identity.lat
            lng: identity.lng
            occupation: identity.occupation
            password: identity.password
            username: identity.username
            Networks: identity.getNetworks().map (network) ->
              return {
                external_ip_v4: network.external_ip_v4
                id: network.id
                identity: network.identity
                internal_ip_v4: network.internal_ip_v4
                isLocal: network.isLocal
                lat: network.lat
                lng: network.lng
                node: network.node
                submask: network.submask
                Node: network.getNode().id
                Hosts: network.getHosts().map (host) ->
                  return {
                    filesystem: host.filesystem
                    online: host.online
                    id: host.id
                    ip: host.ip
                    mac: host.mac
                    machine_name: host.machine_name
                    network: host.network
                    Filesystem: host.getFilesystem()
                  } # Hosts
              } # Networks
          } # Identities
      } # User Object














module.exports = UserRoom



