

Room = require './Room.coffee'



###*
# GeneralRoom, Emitters which does not fit in any category but General
# @class GeneralRoom
# @module Backend
# @submodule Backend.Networking
# @extends Room
###
class GeneralRoom extends Room


  define: ->
    that = @

    ###*
    # Emitter for when user attempts to purchase a network
    # @class Emitter_ShopPurchaseNetwork
    # @submodule Backend.Emitters
    ###
    @addEvent "ShopPurchaseNetwork", (data) ->
      client = that.getClient(@id)

      # TODO HARDCODE
      PRICE = 25000

      db_user = Gotham.LocalDatabase.table("User")
      db_network = Gotham.LocalDatabase.table("Network")
      db_node = Gotham.LocalDatabase.table("Node")
      db_identity = Gotham.LocalDatabase.table "Identity"

      # Node to purchase at
      node = db_node.findOne(id: data.id)

      # The user that purchased
      user = db_user.findOne({id: client.getUser().id})


      # If node or user does not exists
      if node == null or user == null
        console.log "Error, User or node does not exist!"
        return


      # TODO HARDCODED PRICE
      if user.money < PRICE
        client.Socket.emit 'ANNOUNCE', {
          type: "NORMAL"
          message: "You cannot afford this network! You have: #{user.money}$, You need: #{PRICE}$"
        }
        return false



      if user.getIdentities().length < 1
        console.log "User need atleast 1 Identity!"
        return

      # Find a nodes network, then the Provider
      ipProvider = node.getNetwork().getDNS().getProvider()

      externalIP = Gotham.Util.IPTool.nextAvailableIPFromProvider ipProvider
      internalIP = Gotham.Util.IPTool.randomInternalIP()
      MAC = Gotham.Util.IPTool.generateMAC()
      submask = "255.255.255.0"
      dns = "4.4.4.4"
      isLocal = true

      randomizer = Math.floor(Math.random() * 2) + 1
      lat = if randomizer == 1 then (node.lat - 0.5) else (node.lat + 0.5)
      lng = if randomizer == 1 then (node.lng + 0.5) else (node.lng - 0.5)



      # Create DNS Record
      Gotham.LocalDatabase.Model.DNS.create {
        ipv4: externalIP
        provider: ipProvider.id
      }, (_dns) ->

        console.log "|-> DNS Created!"

        # Create the network
        Gotham.LocalDatabase.Model.Network.create {
          submask: submask
          internal_ip_v4: internalIP
          external_ip_v4: externalIP
          mac: MAC
          dns: dns
          isLocal: isLocal
          lat: lat
          lng: lng
          node: node.id
        }, (_network) ->
          console.log "|--> Network Created!"

          Gotham.LocalDatabase.Model.IdentityNetwork.create {
            identity: user.getIdentities()[0].id
            network: _network.id
          }, (identityNetwork) ->
            console.log "|---> Identity => Network Relation created!"

            network = db_network.findOne(id: _network.id)

            # Update networks for the identity
            identity = db_identity.findOne(id: identityNetwork.identity)
            identity.getNetworks()
            identity.Networks.push network

            # Update user money
            user.update({
              money: user.money - PRICE
            })
            client.Socket.emit 'UpdatePlayerMoney', user.money

            client.Socket.emit 'NetworkPurchaseUpdate', {
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
              Hosts: []
            }

    ###*
    # Emitter for when user attempts to purchase a host
    # @class Emitter_ShopPurchaseHost
    # @submodule Backend.Emitters
    ###
    @addEvent "ShopPurchaseHost", (data) ->
      client = that.getClient(@id)
      console.log "[ShopRoom] Calling: ShopPurchaseHost"

      PRICE = 5000

      db_user = Gotham.LocalDatabase.table("User")
      db_network = Gotham.LocalDatabase.table("Network")
      db_node = Gotham.LocalDatabase.table("Node")
      db_host = Gotham.LocalDatabase.table "Host"

      # Node to purchase at
      node = db_node.findOne(id: data.id)

      # The user that purchased
      user = db_user.findOne({id: client.getUser().id})

      # The user that purchased
      network = db_network.findOne({id: data.id})

      # TODO HARDCODED PRICE
      if user.money < PRICE
        client.Socket.emit 'ANNOUNCE', {
          type: "NORMAL"
          message: "You cannot afford this host! You have: #{user.money}$, You need: #{PRICE}$"
        }
        return false



      # Logic to find begin and end ip of the Network
      reservedIPs = network.getHosts().map (host) ->
        return host.ip
      split = network.internal_ip_v4.split(".")
      beginIP = split
      endIP = [split[0], split[1], split[2], 255]

      random = Math.floor(Math.random() * 600000) + 1

      machine_name = "Computer-#{random}"
      online = 1

      ip = Gotham.Util.IPTool.nextAvailableIP(beginIP, endIP, reservedIPs)
      mac = Gotham.Util.IPTool.generateMAC()

      Gotham.LocalDatabase.Model.Host.create {
        machine_name: machine_name
        online: online
        ip: ip
        mac: mac
        filesystem: 1 #TODO
        network: network.id
      }, (_host) ->

        console.log "|-> Host Created!"

        # Update user money
        user.update({
          money: user.money - PRICE
        })
        client.Socket.emit 'UpdatePlayerMoney', user.money


        host = db_host.findOne(id: _host.id)
        host.getNetwork()
        host.getNetwork().getIdentity()


        # Update hosts for network
        network.getHosts()
        network.Hosts.push host

        identity = network.getIdentity()

        client.Socket.emit 'HostPurchaseUpdate', {
          filesystem: host.filesystem
          online: host.online
          id: host.id
          ip: host.ip
          mac: host.mac
          machine_name: host.machine_name
          network: host.network
          Network: {
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
          }
          Identity: {
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
          }
          Filesystem: host.getFilesystem()
        }


























module.exports = GeneralRoom
