
class IPTool

  ###*
  # Find next available ip given a provider
  # @method nextAvailableIP
  # @static
  # @returns {String} the ip
  ###
  @nextAvailableIPFromProvider = (provider) ->
    db_dns = Gotham.LocalDatabase.table "DNS"

    # Find reserved IPS
    reservedIPs = db_dns.find({provider: provider.id}).map (item) ->
      return item.ipv4

    # Begin and end
    beginIP = provider.from_ip.split('.')
    endIP = provider.to_ip.split('.')

    return IPTool.nextAvailableIP(beginIP,endIP, reservedIPs)

  ###*
  # Find next available ip given a begin and end ip
  # @method nextAvailableIP
  # @static
  # @returns {String} the ip
  ###
  @nextAvailableIP  = (beginIP, endIP, reservedIPs)->

    a = parseInt beginIP[0]
    while a <= parseInt endIP[0]
      b = parseInt beginIP[1]
      while b <= parseInt endIP[1]
        c = parseInt beginIP[2]
        while c <= parseInt endIP[2]
          d = parseInt beginIP[3]
          while d <= parseInt endIP[3]

            if d == 0
              d++
              continue

            ip = "#{a}.#{b}.#{c}.#{d}"
            if reservedIPs.indexOf(ip) == -1
              return ip

            d++
          c++
        b++
      a++
      return null

  @randomInternalIP = ->

    spaces  = [
      "10.0.0.0-10.255.255.255",
      "172.16.0.0-172.31.255.255",
      "192.168.0.0-192.168.255.255"
    ]

    # Pick Random Space
    space = spaces[Math.floor(Math.random()*spaces.length)];

    # Set Start and Stop and split into an array
    from = space.split('-')[0].split('.');
    to = space.split('-')[1].split('.');

    seg1 = Math.floor(Math.random() * parseInt(to[1])) + parseInt(from[1])
    seg2 = Math.floor(Math.random() * parseInt(to[2])) + parseInt(from[2])

    return "#{from[0]}.#{seg1}.#{seg2}.1"

  @generateMAC = ->
    return 'XX:XX:XX:XX:XX:XX'.replace /X/g, ->
      '0123456789ABCDEF'.charAt Math.floor(Math.random() * 16)

module.exports = IPTool