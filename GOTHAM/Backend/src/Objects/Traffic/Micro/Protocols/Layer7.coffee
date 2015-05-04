BaseLayer = require './BaseLayer.coffee'

class Layer7 extends BaseLayer

  constructor: (type) ->
    @type = type
    @data = null
    @version = null

  @HTTP = ->
    l7 = new Layer7("HTTP")


    return l7

  @FTP = ->
    l7 = new Layer7("FTP")

    return l7

  @DNS = ->
    l7 = new Layer7("DNS")

    return l7

  @HTTPS = ->
    l7 = new Layer7("HTTPS")

    return l7

  @SFTP = ->
    l7 = new Layer7("SFTP")

    return l7

  @SSH = ->
    l7 = new Layer7("SSH")

    return l7




module.exports = Layer7
