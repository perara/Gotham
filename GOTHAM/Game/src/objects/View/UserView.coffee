

###*
# The user view shows the user data. Example is Name, Money, Experience etc.
# @class UserView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class UserView extends Gotham.Pattern.MVC.View

  constructor: ->
    super


    @movable()
    @click = ->
      @bringToFront()





  create: ->
    @createFrame()
    @createTitles()
    @hide()

    @emitSetExperience()
    @emitSetMoney()

  createTitles: ->
    title = @title = new Gotham.Graphics.Text("Player Information", {font: "bold 50px calibri", fill: "#ffffff", align: "center"});
    title.x = 40
    title.y = 30
    @window.addChild(title)

    # Description Text
    username = @username = new Gotham.Graphics.Text("Username: [NONE]", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
    username.y = 100
    username.x = 40
    @window.addChild(username)

    email = @email = new Gotham.Graphics.Text("Email: [NONE]", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
    email.y = 140
    email.x = 40
    @window.addChild(email)

    money = @money = new Gotham.Graphics.Text("Money: [NONE]", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
    money.y = 180
    money.x = 40
    @window.addChild(money)

    experience = @experience = new Gotham.Graphics.Text("Experience: [NONE]", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
    experience.y = 220
    experience.x = 40
    @window.addChild(experience)

    identities = @identities = new Gotham.Graphics.Text("Identities: [NONE]", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
    identities.y = 100
    identities.x = 400
    @window.addChild(identities)

    networks = @networks = new Gotham.Graphics.Text("Networks: [NONE]", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
    networks.y = 140
    networks.x = 400
    @window.addChild(networks)

    hosts = @hosts = new Gotham.Graphics.Text("Hosts: [NONE]", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
    hosts.y = 180
    hosts.x = 400
    @window.addChild(hosts)

  emitSetMoney: () ->
    that = @
    GothamGame.Network.Socket.on 'UpdatePlayerMoney', (money) ->
      oldMoney = parseInt(that.money.text.replace("Money: ", ""))
      gain = money - oldMoney

      GothamGame.Announce.message "You gained #{gain} money!", "MISSION", 50
      that.money.text = "Money: " + money

  emitSetExperience: () ->
    that = @
    GothamGame.Network.Socket.on 'UpdatePlayerExperience', (experience) ->
      oldExperience = parseInt(that.experience.text.replace("Experience: ", ""))
      gain = experience - oldExperience

      GothamGame.Announce.message "You gained #{gain} experience!", "MISSION", 50
      that.experience.text = "Experience: " + experience


  setUser: (user) ->
    numIdentities = 0
    numNetworks = 0
    numHosts = 0

    # Count Identity, Network and Hosts
    for identity in user.Identities
      numIdentities++
      for network in identity.Networks
        numNetworks++
        for host in network.Hosts
          numHosts++

    @username.text = @username.text.replace "[NONE]", user.username
    @email.text = @email.text.replace "[NONE]", user.email
    @money.text = @money.text.replace "[NONE]", user.money
    @experience.text = @experience.text.replace "[NONE]", user.experience
    @identities.text = @identities.text.replace "[NONE]", numIdentities
    @networks.text = @networks.text.replace "[NONE]", numNetworks
    @hosts.text = @hosts.text.replace "[NONE]", numHosts






  show: ->
    @window.visible = true

  hide: ->
    @window.visible = false

  createFrame: ->

    # Create Window
    window = @window = new Gotham.Graphics.Sprite Gotham.Preload.fetch "user_management_background", "image"
    window.width = 800
    window.height = 700
    window.y = 1080 - 70 - 700
    window.x = 400
    window.interactive = true
    window.mousemove = (e)->

    #window.movable()

    # Create mask background
    windowMask = new Gotham.Graphics.Graphics
    windowMask.beginFill(0x232323, 1)
    windowMask.drawRect(0, 0,  window.width / window.scale.x, window.height / window.scale.y)
    window.addChild windowMask
    window.mask = windowMask

    # Create Frame
    frame = @frame = new Gotham.Graphics.Sprite Gotham.Preload.fetch "user_management_frame", "image"
    frame.width = window.width / window.scale.x
    frame.height = window.height / window.scale.y
    window.addChild frame

    return @addChild window











module.exports = UserView

