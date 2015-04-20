BaseLayer = require './BaseLayer.coffee'

class Layer7 extends BaseLayer

class HTTP extends Layer7
  setType: ->
    return "HTTP"

class FTP extends Layer7
  setType: ->
    return "FTP"

class DNS extends Layer7
  setType: ->
    return "DNS"

class HTTPS extends Layer7
  setType: ->
    return "HTTPS"

class SFTP extends Layer7
  setType: ->
    return "SFTP"

class SSH extends Layer7
  setType: ->
    return "SSH"

module.exports = HTTP
module.exports = FTP
module.exports = DNS
module.exports = HTTPS
module.exports = SFTP
module.exports = SSH
