Room = require './Room.coffee'




class MissionRoom extends Room


  define: ->
    that = @

    @AddEvent "GetMission", (data) ->
      client = that.GetClient(@id)


      that.log.info "[MissionRoom] GetMission called" + data

      that.Database.Model.Mission.all(include: [{ all: true, nested:true}])
      .then (missions) ->

        console.log ":D"

        client.Socket.emit 'GetMission', JSON.stringify(missions)





module.exports = MissionRoom