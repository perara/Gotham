class Protocols

  # Layer 2
  Ethernet = require 'Ethernet'
  Wifi = require 'Wifi'

  # Layer 3
  ICMP = require 'ICMP'
  IP = require 'IP'

  # Layer 4
  TCP = require 'TCP'
  UDP = require 'UDP'

  # Layer 6
  NoEncryption = require 'NoEncryption'
  SSL = require 'SSL'
  TLS = require 'TLS'
  DTLS = require 'DTLS'

  # Layer 7
  HTTP = require 'HTTP'
  FTP = require 'FTP'
  DNS = require 'DNS'
  HTTPS = require 'HTTPS'
  SFTP = require 'SFTP'
  SSH = require 'SSH'

module.exports = Protocols