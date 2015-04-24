Room = require './Room.coffee'
When = require 'when'



class MissionRoom extends Room


  define: ->
    that = @

    @AddEvent "AcceptMission", (mission) ->
      that.log.info "[MissionRoom] AcceptMission called"
      client = that.GetClient(@id)

      that.Database.Model.UserMission.findOne(
        where:
          mission: mission.id
          user: client.GetUser().id
      ).then (record) ->

        # Return with error if record exists. Means user has already started Mission
        if record
          client.Socket.emit 'ERROR', "ERROR_MISSION_ONGOING", "You cannot start the same mission twice!" # TODO Multilangual
          return

        # Start the Mission for the User
        # Create a UserMission entity
        that.Database.Model.UserMission.create(
          user: client.GetUser().id
          mission: mission.id
        ).then (userMission) ->

          # Find Mission Entity from local db
          mission = Gotham.LocalDatabase.table("missions").find({id : userMission.mission})[0].mission

          # Mission entry is now created
          client.Socket.emit 'AcceptMission', mission


    @AddEvent "AbandonMission", (mission) ->
      that.log.info "[MissionRoom] AbandonMission called"
      client = that.GetClient(@id)

      that.Database.Model.UserMission.findOne(
        where:
          mission: mission.id
          user: client.GetUser().id
      ).then (record) ->

        if not record
          client.Socket.emit 'ERROR', "ERROR_MISSION_NOT_ONGOING", "You cannot abandon a mission not currently ongoing!" # TODO Multilangual
          return

        record.destroy().on 'success', (u) ->
          if u

            # Find Mission Entity from local db
            mission = Gotham.LocalDatabase.table("missions").find({id : record.mission})[0].mission

            client.Socket.emit 'AbandonMission', mission



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

        console.log usermission
        ret = []
        for usermission in usermissions

          ret.push usermission.Mission

        missions.ongoing = ret


      When.all(promises).then () ->
        client.Socket.emit 'GetMission', missions



module.exports = MissionRoom