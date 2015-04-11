View = require '../View/TerminalView.coffee'

class TerminalController extends Gotham.Pattern.MVC.Controller

  # Static References to inner classes
  @Console = Console

  # KeyCode constrants
  @KeyCode:
    TAB: 9
    ENTER: 13
    ARROW_UP: 38
    ARROW_DOWN: 40


  constructor: (name) ->
    super View, name
    that = @


    @console = undefined
    @_data = undefined
    @_fs = undefined
    @Commands =
      ls: (args) ->
        that.console.add that._fs.ls args
      cd: (args) ->
        that._fs.cd args
      mv: (args) ->
        that._fs.mv args
      clear: (args) ->
        that.console.clear()


  create: ->
    @console = console = @View.setConsole new Console

    @Networking()
    @HandleInput()

  Networking: () ->
    that = @

    GothamGame.network.Socket.emit 'GetHost'
    GothamGame.network.Socket.on "GetHost", (json)->

      json = JSON.parse(json)

      that._data = json
      that._fs = new Filesystem(json.Filesystem)
      that._fs.onError = (errMsg) ->
        that.console.add errMsg

      that.Boot()



  # Output the boot sequence of the virtual machine
  #
  Boot: ->
    @console.addArray [
      "Welcome to Ubuntu 14.10 (GNU/Linux 3.16.0-23-generic x86_64)",
      ""
      " * Documentation:  https://help.ubuntu.com/",
      "",
      "  System information as of Sat Mar 21 14:55:04 CET 2015",
      "",
      "  System load:  0.18                Processes:           162",
      "  Usage of /:   16.6% of 157.36GB   Users logged in:     0",
      "  Memory usage: 48%                 IP address for eth0: #{@._data.ip}",
      "  Swap usage:   0%                  IP address for eth1: 10.131.240.142",
      "",
      "  Graph this data and manage this system at:",
      "    https://landscape.canonical.com/",
      "",
      "23 packages can be updated.",
      "19 updates are security updates.",
      "",
      "Last login: Fri Mar 20 17:09:49 2015 from grm-studby-128-39-148-43.studby.uia.no"
    ]
    @View.Redraw()


  # Handle Input Event (Keydown)
  #
  HandleInput: ->
    that = @
    input = @View._input

    # Action when tab is hit
    tab = (e, obj) ->
      e.preventDefault()

      value = $(obj).val()
      that.__tabCount = if not that.__tabCount then 0 else that.__tabCount
      that.__tabCount = (that.__tabCount + 1) %% 2

      command = new Command that , value


      if command.isCommand()

        if that.__tabCount is 1

          files = that._fs.findFiles command._args

          output = ""
          for file in files
            ext = if file.extension != "dir" then ".#{file.extension}" else ""
            output += "#{file.name}#{ext}    "

          if files.length == 1
            $(obj).val("#{command._command} #{files[0].name}")
          else if files.length > 1
            that.console.add output
            that.View.Redraw()




    # Action when Enter is hit
    enter = (e, obj) ->
      val = $(obj).val();
      $(obj).val("")

      that.ParseInput val

    # Action when Arrows up/down is hit
    arrow = (e, obj) ->
      isUp = e.which is TerminalController.KeyCode.ARROW_UP

      historyPointer = if isUp then that.console.incrementHistoryPointer(-1) else that.console.incrementHistoryPointer(1)
      historyItem = that.console.getHistoryAt historyPointer
      $(obj).val historyItem._command




    input.on 'keydown', (e) ->
      keycode = e.which

      if keycode is TerminalController.KeyCode.ENTER then enter(e, @)
      if keycode is TerminalController.KeyCode.TAB then tab(e, @) else that.__tabCount = 0
      if keycode is TerminalController.KeyCode.ARROW_UP or keycode is TerminalController.ARROW_DOWN then arrow(e, @)

  ParseInput: (input) ->

    command = new Command @, input

    @console.add "#{@_data.Person.givenname}@#{@_data.machine_name}:~# #{command.getText()}"
    @console.addHistory command

    if command.isCommand()
      command.execute()
    else
      @console.add "#{command.getText()}: command not found"

    @View.Redraw()

  Show: () ->
    @View.terminal_frame.show()
  Hide: () ->
    @View.terminal_frame.hide()


# Command class
class Command

  constructor: (tC, input) ->
    @_terminalController = tC

    # Raw Input
    @_input = input

    # Reference to the command
    @_refCommand = undefined

    @_command = undefined
    @_args = undefined


    @Parse()

  isCommand: ->
    return !!@_refCommand

  Parse: ->
    split = @_input.split(" ")
    @_command = split[0]
    split.splice 0,1
    @_args = split

    # Determine if command exists
    if (@_command of @_terminalController.Commands)
      @_refCommand = @_terminalController.Commands[@_command]

  getCommandText: ->
    return @_command

  getArgs: ->
    return @_args

  execute: ->
    if not @_refCommand then throw new Error "RefCommand is not defined!"
    @_refCommand(@_args)


  getText: ->
    return @_input


class Filesystem

  constructor: (json) ->


    @_fs = @Parse(json.data)
    @_root = @Parse(json.data)
    @onError = ->


  ToRoot: ->
    root = @_fs
    while @_fs.parent
      root = @_fs.parent
    return root

  Parse: (root) ->
    # Function for creating parent node on "node"
    createParentNode = (node, parent) ->
      node.parent = parent

      for key, value of node.children
        createParentNode(value, node)

    createParentNode root, null

    return root

  # Attempts to navigate through the file system, returning the resulting node if found
  #
  # @param path {String} - The path
  # @return {FileSystemItem} The resulting node, Null if not found
  navigate : (path) ->
    startRoot = path.startsWith "/"

    paths = path.split("/")

    curr = if startRoot then @ToRoot() else @_fs

    for _path in paths
      if not curr then break

      # Same directory, do nothing
      if _path == "" or _path == "."
        continue

      # Parent directory
      if _path == ".."
        curr = curr.parent
        continue

      # Search after dir
      found = null
      for filename, child of curr.children
        if filename is _path
          found = child
          break
      curr = found

    return curr

  # Find files in current directory given a pattern
  #
  # @param pattern {Array(String)} search pattern
  # @return {Array} Array of results
  findFiles: (args) ->

    matches = []
    for pattern in args
      for filename, child of @_fs.children
        #console.log "Pattern: " + pattern + " | ChildName: " + child.Name + " | Flag: " + (pattern.indexOf child.Name > -1)
        if filename.contains pattern
          matches.push
            extension: child.extension
            name: filename
    return matches

  ls: ->
    output = ""

    for filename, child of @_fs.children
      ext = if child.extension != "dir" then ".#{child.extension}" else ""
      output += "#{filename}#{ext}    "
    return output

  mv: (args) ->

    sourceNode =  @navigate args[0] #TODO
    targetNode = @navigate args[1] #TODO

    if sourceNode is targetNode
      return

    if targetNode is null
      sourceNode.Name = args[1]
      return

    # Delete Parent's child reference
    sourceNode.parent.children.remove sourceNode

    # Delete Parent reference
    sourceNode.parent = null

    # Add source as a Child to the target
    targetNode.children.push sourceNode

    # Add source's parent to the target
    sourceNode.parent = targetNode



  cd: (path) ->

    if path.length > 0
      path = path[0] #TODO
    else
      path = ""

    curr = @navigate path

    if curr
      if curr.extension is "dir"
        @_fs = curr
      else
        @onError "-bash: cd: #{path}: Not a directory"
    else
      @onError "-bash: cd: #{path}: No such file or directory"

  GetPointer: ->
    return @_fs

  Print: () ->
    console.log @_fs





# Console Class
# Contains all data of the console window, Acts much like an array, but have some extended functionality for
# easy manipulation
#
class Console

  constructor: ->
    @_console = []
    @_history = []
    @_historyPointer = 0

  getAt: (index) ->
    return @_console[index]

  all: () ->
    return @_console

  addAt: (index, text) ->
    @_console.splice index, 0, text

  appendTo: (index, text) ->
    @_console[index] += text

  add: (text) ->
    @_console.push text

  addArray: (arr) ->
    for i in arr
      @add i

  addBefore: (text) ->
    @addAt 0, text

  clear: ->
    @_console.length = 0

  clearHistory: ->
    @_history.length = 0

  getHistory: ->
    return @_history

  getHistoryAt: (index) ->
    return @_history[index %% @_history.length]

  addHistory: (text) ->
    @_history.push text
    @_historyPointer = @_history.length

  incrementHistoryPointer: (add) ->
    @_historyPointer+= add
    return @_historyPointer




module.exports = TerminalController