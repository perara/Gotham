

###*
# View for the Identity + Host/Networks
# @class IdentityView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class IdentityView extends Gotham.Pattern.MVC.View

  constructor: ->
    super

    @movable()

    @click = ->
      @bringToFront()

    # Identity
    @selectedIdentity = null
    @identityCount = 0
    @identityTextMapping = {}

    # Network
    @networkCount = 0
    @networkY = 0




  create: ->
    window = @createFrame()
    @createTerminal(window)
    @createUserInfo(window)


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

  createTerminal: (window) ->

    title = new Gotham.Graphics.Text("Available Hosts", {font: "bold 50px calibri", fill: "#ffffff", align: "center"});
    title.x = 40
    title.y = 30
    window.addChild(title)


    networkContainerTexture =  new Gotham.Graphics.Graphics()
    networkContainerTexture.beginFill(0x00ff00, 1)
    networkContainerTexture.drawRect(0, 0, 360,660)
    networkContainerTexture.endFill()
    networkContainerTexture = networkContainerTexture.generateTexture()

    networkContainer = @networkContainer = new Gotham.Graphics.Sprite networkContainerTexture
    networkContainer.x = 40
    networkContainer.y = 90

    window.addChild(networkContainer)

  createUserInfo: (window) ->
    title = new Gotham.Graphics.Text("Identities", {font: "bold 50px calibri", fill: "#ffffff", align: "center"});
    title.x = 450
    title.y = 30
    window.addChild(title)





  addIdentity: (identity) ->
    that = @
    @identityCount += 1

    container = new Gotham.Graphics.Graphics()
    container.visible = false

    if not @selectedIdentity
      container.visible = true
      @selectedIdentity = container

    @window.addChild container

    createItem = (title, value) ->
      # Description Text
      item = new Gotham.Graphics.Text("#{title}:", {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
      item.x = 450
      container.addChild(item)

      # Mod Item is the item that should be modified (data input)
      modItem = new Gotham.Graphics.Text(value, {font: "bold 25px calibri", fill: "#ffffff", align: "center"});
      modItem.x = 600
      container.addChild(modItem)
      return [item, modItem]

    y = 85
    for type, value of identity
      texts = createItem type.replace("_", " ").toTitleCase(), value
      descriptionText = texts[0]
      modText = texts[1]

      descriptionText.y = y
      modText.y = y
      y += 45

    button = new Gotham.Controls.Button @identityCount, 50, 50, {toggle: false, textSize: 100}
    button.x = 450 + (60 * (@identityCount-1))
    button.y = y
    button.identity = container
    button.setBackground if identity.active then 0x00ff00 else 0x808080
    button.onClick = ->
      that.selectedIdentity.visible = false

      that.selectedIdentity = @identity
      @identity.visible = true

    @window.addChild button


    # Make frame on top at the end of insertions
    #@frame.bringToFront() # TODO , this messes up interactive for button



  """for type, value of identity
      @identityTextMapping[type].setText value
    """






  addNetwork: (network) ->

    db_node = Gotham.Database.table("node")



    networkSprite = new Gotham.Graphics.Sprite Gotham.Preload.fetch("user_management_network_item", "image")
    networkSprite.y = @networkY
    networkSprite.interactive = true

    text = new Gotham.Graphics.Text("IP: #{network.external_ip_v4} Mask: #{network.submask}\nNode: #{db_node.findOne({id: network.Node}).name}", {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    text.x = 5
    text.y = 5
    networkSprite.addChild text


    @networkContainer.addChild networkSprite


    @networkY += 70
    @networkCount++


  addHost: (network, host) ->

    hostSprite = new Gotham.Graphics.Sprite Gotham.Preload.fetch("user_mangement_host", "image")
    hostSprite.x = 5
    hostSprite.width -= 10
    hostSprite.y = @networkY
    hostSprite.interactive = true
    @networkContainer.addChild hostSprite

    text = new Gotham.Graphics.Text("Machine: #{host.machine_name} IP: #{host.ip}\nMAC: #{host.mac} Online: #{host.online}", {font: "bold 20px calibri", fill: "#ffffff", align: "left"});
    text.x = 5
    text.y = 5
    hostSprite.addChild text

    @networkY += hostSprite.height + 10
    return hostSprite




module.exports = IdentityView

