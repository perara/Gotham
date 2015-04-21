Room = require './Room.coffee'
When = require 'when'



class MissionRoom extends Room


  define: ->
    that = @

    @AddEvent "GetMission", (data) ->
      that.log.info "[MissionRoom] GetMission called" + data
      client = that.GetClient(@id)

      missions =
        ongoing: null
        available: null


      promises = []

      promises.push that.Database.Model.Mission.all(include: [{ all: true, nested:true}]).then (_missions) ->
        missions.available = _missions

      #include: [{ all: true, nested:true}]
      #[{ all: true, nested:true}]
      promises.push that.Database.Model.UserMission.all(
        where: user: 1
        include: [{ all: true, nested:true}]).then (usermissions) ->

        ret = []
        for usermission in usermissions
          ret.push usermission.Mission

        missions.ongoing = ret


      When.all(promises).then () ->
        client.Socket.emit 'GetMission', missions



module.exports = MissionRoom