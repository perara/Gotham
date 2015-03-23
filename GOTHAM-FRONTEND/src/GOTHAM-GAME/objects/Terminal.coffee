


class Terminal extends Gotham.Graphics.Container

  constructor: ->
    that = @
    @name = "Terminal"
    @setNetworkHub "terminal"

    @_data = null
    @_fs = null
    @_loaded = false


    # Fetches terminal data
    @addNetworkMethod "getTerminal", (json)->
      data = JSON.parse(json)
      that._data = data

      that._fs = data.Filesystem

      # Create parent node in each of the items
      createParentNode = (node, parent) ->
        node.parent = parent

        # Create parent for node's children
        for childNode in node.Children
          createParentNode childNode, node


      # Create the parent node property
      createParentNode that._fs, null



      # Set loaded top true and run startup
      that._loaded = true
      that.Startup()

    @network.onConnect = (connection) ->
      connection.server.getTerminal();


    @stage = null
    @children = []
    @_commandHistory = []
    @_consoleData = []
    @_historyPointer = 0


  create: ->
    that = @
    @terminal_frame = terminal_frame = $('<div\>',
      {
        id: "terminal_frame"
        style: """
          width: 400px;
          height: 350px;
          background-color: red;
          position: fixed;
          top: 0px;
          left: 0px;
        """
      })


    terminal_title_frame = $('<div\>',
      {
        id: "terminal_title_frame"
        style: """
          width: 100%;
          height: 5%;
          min-height: 25px;
          background-color: black;
          border-bottom: 1px solid gray;
          position: relative;
          top: 0px;
          left: 0px;
        """
      })

    terminal_title_text = $('<div\>',
      {
        id: "terminal_title_text"
        style: """
          text-align: center;
          color: white;
          position: relative;
          top: 30%
        """
        text: "Terminal x64"
      })


    terminal_console_frame = $('<div\>',
      {
        id: "terminal_console_frame"
        style: """
          width: 100%;
          height: 85%;
          border-bottom: 1px solid gray;
          position: relative;
          top: 0px;
          left: 0px;
        """
      })


    @terminal_console_content = terminal_console_content = $('<div\>',
      {
        id: "terminal_console_frame_content"
        style: """
          width: 98%;
          height: 99%;
          background-image: url('./assets/img/terminal_background.png');
          background-size:cover;
          border-bottom: 1px solid gray;
          font-family: Courier New;
          font-size: 11px;
          position: relative;
          top: 0px;
          left: 0px;
          color: white;
          overflow-y: scroll;
          padding: 1%;
        """
        text: ""
      })

    terminal_input_frame = $('<div\>',
      {
        id: "terminal_input_frame"
        style: """
          width: 100%;
          height: 10%;
          background-color: gray;
          position: relative;
        """
      })


    terminal_input_field = $('<input\>',
      {
        type: "text"
        id: "terminal_input_field"
        style: """
          width: 99%;
          height: 100%;
          background-color: black;
          display: inline-block;
          font-family: Courier New;
          font-size: 11px;
          position: relative;
          padding:0;
          padding-left: 1%;
          border: 0;
          color: white;
          outline: none;
        """
      })

    terminal_input_field.on 'keydown', (e) ->
      if not that._loaded then  e.preventDefault()

      TAB = 9
      ENTER = 13
      ARROW_UP = 38
      ARROW_DOWN = 40

      input = $(@).val();

      if e.which is TAB
        that.__tabCount += 1
        e.preventDefault()
        # Check if input is and command with args
        if that.IsCommand input
          command = input.split(" ").splice(0, 1) + " "
          pattern = input.split(" ").splice(1, input.split(" ").length - 1).join(" ")
          matches = that.SearchNode pattern
        else
          command = ""
          pattern = input
          matches = that.SearchNode pattern

        # If only 1 result, append to the input field
        if matches.length == 1
          $(@).val(command + matches[0].Name)

        # If multiple, push alternatives to console (Only on second tab)
        else
          if that.__tabCount > 1
            that.__tabCount = 0
            output = ""
            for match in matches
              output += "#{match.Name}.#{match.Extension}    "
            that._consoleData.push(output)
            that.RedrawConsole()
      else
        that.__tabCount = 0



      if e.which is ENTER
        that.SendCommand input
        $(@).val("")

      if e.which is ARROW_UP
        text = that.HistoryPointer(-1)
        $(@).val(text)

      if e.which is ARROW_DOWN
        text = that.HistoryPointer(1)
        $(@).val(text)


    $(terminal_frame).append(terminal_title_frame)
    $(terminal_title_frame).append(terminal_title_text)

    $(terminal_frame).append(terminal_console_frame)
    $(terminal_console_frame).append(terminal_console_content)

    $(terminal_frame).append(terminal_input_frame)
    $(terminal_input_frame).append(terminal_input_field)


    $(terminal_frame).draggable({handle: terminal_title_frame});
    $(terminal_frame).resizable();

    $("body").append(@terminal_frame);



  # Function which processes the action of scrolling in the history of the input field,
  #
  # @param [Integer] add Weither to add or substract to the pointer
  #
  # @return [String] the corresponding item that was scrolled to.
  #
  HistoryPointer: (add) ->
    @_historyPointer += add
    pointer = @_historyPointer %% if @_commandHistory.length is 0 then 1 else @_commandHistory.length
    return @_commandHistory[pointer];

  # Shows the terminal
  Show: ()->
    $(@terminal_frame).show();

  # Hides the terminal
  Hide: ()->
    $(@terminal_frame).remove();

  # Creates a startup screen for the terminal
  # This is to simulate login behaviour
  #
  Startup: ()->
    @_consoleData.push "Welcome to Ubuntu 14.10 (GNU/Linux 3.16.0-23-generic x86_64)"
    @_consoleData.push ""
    @_consoleData.push " * Documentation:  https://help.ubuntu.com/"
    @_consoleData.push ""
    @_consoleData.push "  System information as of Sat Mar 21 14:55:04 CET 2015"
    @_consoleData.push ""
    @_consoleData.push "  System load:  0.18                Processes:           162"
    @_consoleData.push "  Usage of /:   16.6% of 157.36GB   Users logged in:     0"
    @_consoleData.push "  Memory usage: 48%                 IP address for eth0: #{@._data.Ip}"
    @_consoleData.push "  Swap usage:   0%                  IP address for eth1: 10.131.240.142"
    @_consoleData.push ""
    @_consoleData.push "  Graph this data and manage this system at:"
    @_consoleData.push "    https://landscape.canonical.com/"
    @_consoleData.push ""
    @_consoleData.push "23 packages can be updated."
    @_consoleData.push "19 updates are security updates."
    @_consoleData.push ""
    @_consoleData.push "Last login: Fri Mar 20 17:09:49 2015 from grm-studby-128-39-148-43.studby.uia.no"
    @RedrawConsole()


  # Redraws all text in the console, refreshing it
  #
  RedrawConsole: ->
    $(@terminal_console_content).html(@_consoleData.join("<br/>"))
    objDiv = document.getElementById("terminal_console_frame_content");
    objDiv.scrollTop = objDiv.scrollHeight;


  # Funcion which sends the command and adds it to history,
  # This is just a middle man between parsing and redrawing
  #
  # @param [String] message The message/command sent in from the input field
  #
  SendCommand: (message) ->
    @_consoleData.push "#{@_data.Owner.Givenname}@#{@_data.MachineName}:~# #{message}"
    @_commandHistory.push message
    @ParseCommand message
    @RedrawConsole()


  # Parses the command from the input field, returning an result
  #
  # @param [String] command The command to be parsed
  #
  # These commands are defined and scripted accordingly
  #
  ParseCommand: (commandstr) ->


    # Ignore to parse empty commands
    if commandstr is ""
      return


    split = commandstr.split(" ")
    command = split[0] # The command
    split.splice(0, 1) # Remove command from split
    args = split #  # The arguments


    # Return if command does not exists
    if not (command of Commands)
      @_consoleData.push "#{command}: command not found"
      return

    # Run command
    Commands[command](@, args)

  # Searches a node's children name given an pattern (File and Directory names)
  #
  # @param[String] pattern - The search pattern
  # @returns [Array] List of matches
  #
  SearchNode: (pattern) ->
    fs = @._fs
    pattern.replace(" ", "")
    matches = []

    for child in fs.Children
      #console.log "Pattern: " + pattern + " | ChildName: " + child.Name + " | Flag: " + (pattern.indexOf child.Name > -1)
      if child.Name.contains pattern
        matches.push child
    return matches

  # Check if the first part of the string is a command
  # @param[String] str The input string
  # @returns [Boolean True is is a command, false if not
  #
  IsCommand: (str) ->
    str = str.split(" ")

    if str.length > 0
      # check if its a command
      if str[0] of Commands
        return true
    return false






  # List of possible privileges a user can have
  #
  Privileges =
    Root: 1
    User: 2
    Guest: 3

  # List of supported commands
  Commands =
    # List all children of an directory
    # @param[Terminal] obj The terminal object
    ls: (obj)->
      # Fetch file system
      fs = obj._fs

      # File append string
      files = ""

      # For each of this nodes items, append to fiels
      for item in fs.Children

        # Determine weither to show extension
        ext = if item.Extension is "dir" then "" else ".#{item.Extension}"

        # Append the file
        files += "#{item.Name}#{ext}    "

      # Push to console the result
      obj._consoleData.push files

    # Navigates the file structure
    # @param[Terminal] obj The terminal object
    # @param[Array] args List of arguments
    #
    cd: (obj, args)->
      # If no args, then set empty path
      if not args[0] then path = "" else path = args[0]

      # If arg is empty, go to root
      if path is "" or path is "/"
        obj._fs = obj._data.Filesystem
        return

      # If first character of the path is /, go to root
      if path[0] is "/"
        obj._fs = obj._data.Filesystem

      # Split the path and remove empty items ("")
      pathArr = path.split("/").filter (item) ->
        if item is "" then return undefined else item



      # Attempt to iterate through the pathlist
      # startLocation is where the terminal is currently at.
      startLocation = obj._fs
      for pathItem in pathArr

        # If the startLocation failed, means the path does not exists
        if startLocation is null
          break

        # Same node
        if pathItem is "."
          continue

        # Parent Node
        else if pathItem is ".."
          startLocation = startLocation.parent

        # Children path
        else
          found = null
          for child in startLocation.Children
            if child.Name is pathItem
              found = child
              break
          startLocation = found

      if startLocation is null
        obj._consoleData.push "-bash: cd: #{path}: No such file or directory"
      else
        if startLocation.Extension is "dir"
          obj._fs = startLocation
        else
          obj._consoleData.push "-bash: cd: #{path}: Not a directory"


    # Pings an host
    ping: ->

    # Clears the terminal output
    # @param[Terminal] obj The terminal object
    clear: (obj) ->
      obj._consoleData.splice(0,obj._consoleData.length)







module.exports = Terminal