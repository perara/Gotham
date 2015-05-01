Application = require './Application.coffee'

#http://ha.ckers.org/slowloris/slowloris.pl

class Slowloris extends Application



  @Command = "slowloris.pl"


  constructor: (command) ->
    super command

    @Packet = {}


  # Boot sequence of the application
  boot: ->
    return ["CCCCCCCCCCOOCCOOOOO888@8@8888OOOOCCOOO888888888@@@@@@@@@8@8@@@@888OOCooocccc::::",
       "CCCCCCCCCCCCCCCOO888@888888OOOCCCOOOO888888888888@88888@@@@@@@888@8OOCCoococc:::",
       "CCCCCCCCCCCCCCOO88@@888888OOOOOOOOOO8888888O88888888O8O8OOO8888@88@@8OOCOOOCoc::",
       "CCCCooooooCCCO88@@8@88@888OOOOOOO88888888888OOOOOOOOOOCCCCCOOOO888@8888OOOCc::::",
       "CooCoCoooCCCO8@88@8888888OOO888888888888888888OOOOCCCooooooooCCOOO8888888Cocooc:",
       "ooooooCoCCC88@88888@888OO8888888888888888O8O8888OOCCCooooccccccCOOOO88@888OCoccc",
       "ooooCCOO8O888888888@88O8OO88888OO888O8888OOOO88888OCocoococ::ccooCOO8O888888Cooo",
       "oCCCCCCO8OOOCCCOO88@88OOOOOO8888O888OOOOOCOO88888O8OOOCooCocc:::coCOOO888888OOCC",
       "oCCCCCOOO88OCooCO88@8OOOOOO88O888888OOCCCCoCOOO8888OOOOOOOCoc::::coCOOOO888O88OC",
       "oCCCCOO88OOCCCCOO8@@8OOCOOOOO8888888OoocccccoCO8O8OO88OOOOOCc.:ccooCCOOOO88888OO",
       "CCCOOOO88OOCCOOO8@888OOCCoooCOO8888Ooc::...::coOO88888O888OOo:cocooCCCCOOOOOO88O",
       "CCCOO88888OOCOO8@@888OCcc:::cCOO888Oc..... ....cCOOOOOOOOOOOc.:cooooCCCOOOOOOOOO",
       "OOOOOO88888OOOO8@8@8Ooc:.:...cOO8O88c.      .  .coOOO888OOOOCoooooccoCOOOOOCOOOO",
       "OOOOO888@8@88888888Oo:. .  ...cO888Oc..          :oOOOOOOOOOCCoocooCoCoCOOOOOOOO",
       "COOO888@88888888888Oo:.       .O8888C:  .oCOo.  ...cCCCOOOoooooocccooooooooCCCOO",
       "CCCCOO888888O888888Oo. .o8Oo. .cO88Oo:       :. .:..ccoCCCooCooccooccccoooooCCCC",
       "coooCCO8@88OO8O888Oo:::... ..  :cO8Oc. . .....  :.  .:ccCoooooccoooocccccooooCCC",
       ":ccooooCO888OOOO8OOc..:...::. .co8@8Coc::..  ....  ..:cooCooooccccc::::ccooCCooC",
       ".:::coocccoO8OOOOOOC:..::....coCO8@8OOCCOc:...  ....:ccoooocccc:::::::::cooooooC",
       "....::::ccccoCCOOOOOCc......:oCO8@8@88OCCCoccccc::c::.:oCcc:::cccc:..::::coooooo",
       ".......::::::::cCCCCCCoocc:cO888@8888OOOOCOOOCoocc::.:cocc::cc:::...:::coocccccc",
       "...........:::..:coCCCCCCCO88OOOO8OOOCCooCCCooccc::::ccc::::::.......:ccocccc:co",
       ".............::....:oCCoooooCOOCCOCCCoccococc:::::coc::::....... ...:::cccc:cooo",
       " ..... ............. .coocoooCCoco:::ccccccc:::ccc::..........  ....:::cc::::coC",
       "   .  . ...    .... ..  .:cccoCooc:..  ::cccc:::c:.. ......... ......::::c:cccco",
       "  .  .. ... ..    .. ..   ..:...:cooc::cccccc:.....  .........  .....:::::ccoocc",
       "       .   .         .. ..::cccc:.::ccoocc:. ........... ..  . ..:::.:::::::ccco",
       " Welcome to Slowloris - the low bandwidth, yet greedy and poisonous HTTP client"]

  switches: ->
    that = @
    return [

      # Help
      ['-h', '--help', 'Show Help', ->
        that.Console.addArray @toString().split("\n")
      ]
      # Version
      ['-V', '--version', 'Show version number', (key, val)->
        that.Console.add "Version 0.7-GOTHAM"
      ]
      # DNS
      ['-dns', '--hostname STRING', 'The hostname to attack', (key, val)->
        console.log val
        that.Packet.dns = val
      ]
      #  PORT
      ['-port', '--port NUMBER', 'Target Port', (key, val)->
        that.Packet.port = val
      ]
      # SHOST
      ['-shost', '--stealthhost STRING', 'If you know the server has multiple webservers running on it in virtual hosts, you can send the attack to a seperate virtual host using the -shost variable.  This way the logs that are created will go to a different virtual host log file, but only if they are kept separately.', (key, val)->
        that.Packet.shost = val
      ]

      # Connections
      ['-num', '--connections NUMBER', 'Number of connections to open to the target', (key, val)->
        that.Packet.num = val
      ]
      # TCP Timeout
      ['-tcpto', '--tcptimeout NUMBER', 'TCP Timeout (TODO)', (key, val)->
        that.Packet.tcpto = val
      ]
      # Re try  Timeout
      ['-timeout', '--timeout NUMBER', 'Retry timeout (TODO)', (key, val)->
        that.Packet.timeout = val
      ]
      # HTTPREADY ("TODO")
      ['-httpready', '--httpready', 'HTTPReady only follows certain rules so with a switch Slowloris can bypass HTTPReady by sending the attack as a POST verses a GET or HEAD request with the -httpready switch.', (key, val)->
        that.Packet.httpready = val
      ]
      # Target HTTPS
      ['-https', '--https', 'Targetting HTTPS', (key, val)->
        that.Packet.https = val
      ]
      # Target HTTPS
      ['-test', '--test', 'Benchmarking Test', (key, val)->
        that.Packet.test = true
      ]
    ]

  printUsage: () ->
    @Console.addArray [
      "Usage:"
      ""
      "     perl ./slowloris.pl -dns [www.example.com] -options"
      ""
      "     Type 'perldoc ./slowloris.pl' for help with options."
      ""
    ]

  execute: ->
    that = @
    @Console.addArray @boot()
    parser = @ArgumentParser()

    # If no arguments
    if @Arguments.length == 0
      @printUsage()
    parser.on ->
      that.printUsage()

    # Parse arguments
    parser.parse(@Arguments)



    if not  @Packet.dns
      @printUsage()
    else

      # Default
      if not @Packet.port
        @Packet.port = 80
        @Console.add "Defaulting to port 80"

      if not @Packet.tcpto
        @Packet.tcpto = 5
        @Console.add "Defaulting to a 5 second tcp connection timeout."

      @Console.add "Multithreading enabled."

      if not @Packet.timeout
        @Packet.timeout = 100
        @Console.add "Defaulting to a 100 second re-try timeout."

      if not @Packet.connections
        @Packet.connections = 1000
        @Console.add "Defaulting to 1000 connections."

      if @Packet.test
        times = [2, 30, 90, 240, 500]
        totalTime = 0
        totalTime += time for time in times
        totalTime = totalTime / 60

        @Console.add "This test could take up to #{totalTime} minutes.";

        # Create Payload
        @Packet.payload =
        "GET /$rand HTTP/1.1\r\n"
        "Host: $sendhost\r\n"
        "User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.503l3; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; MSOffice 12)\r\n"
        "Content-Length: 42\r\n"

        # Emulate connection successfull #TODO - Should connect to a HOST (DNS)
        if true
          @Console.add "Connection successful, now comes the waiting game...\n"
        else
          @Console.add "Uhm... I can't connect to #{@Packet.dns}:#{@Packet.port}"
          @Console.add "Is something wrong?\nDying.\n"
          return

          # When connected but cant send (CANNOT REACH BECAUSE FIREWALL ETC)
          #@Console.add "That's odd - I connected but couldn't send the data to $host:$port."
          #@Console.add "Is something wrong?\nDying.\n"

        for time in times
          @Console.add "Trying a #{time} second delay."
          @Console.add "\tWorked." #TODO - should fail on above 90 second delay

        @Console.add "Remote server closed socket."
        @Console.add "Use 90 seconds for -timeout." # TODO
        return









module.exports = Slowloris