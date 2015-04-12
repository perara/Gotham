class Layer6 extends BaseLayer
  constructor: (hash, version) ->
    @hash = hash
    @version = version

class NoEncryption extends Layer6
  setType: ->
    return "NoEncryption"

class SSL extends Layer6
  setType: ->
    return "SSL"

class TLS extends Layer6
  setType: ->
    return "TLS"

class DTLS extends Layer6
  setType: ->
    return "DTLS"

module.exports = NoEncryption
module.exports = SSL
module.exports = TLS
module.exports = DTLS
