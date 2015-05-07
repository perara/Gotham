View = require '../View/TerminalView.coffee'


###*
# This class keeps track of the terminal data + redrawing of the terminal.
# @class TerminalController
# @module Frontend
# @submodule Frontend.Controllers
# @namespace GothamGame.Controllers
# @constructor
# @param name {String} Name of the Controller
# @extends Gotham.Pattern.MVC.Controller
###
class TerminalController extends Gotham.Pattern.MVC.Controller

  # Keycodes
  @KEYCODE:
    TAB: 9
    ENTER: 13
    ARROW_UP: 38
    ARROW_DOWN: 40



  constructor: (name) ->
    super View, name

    @data = undefined
    @filesystem = undefined
    @console = undefined


    @host = undefined
    @identity = undefined
    @Network = undefined

  create: ->
    that = @

    # Console Initialize
    @console = new GothamGame.Terminal.Console()
    @console.redraw = ->
      that.View.redraw()
    @View.setConsole @console


    # Filesystem Initialize
    @filesystem = new GothamGame.Terminal.Filesystem(@host.Filesystem)
    @filesystem.onError = (error) ->
      console.add error


    @setupInput()

    @boot()



  # Handle Input Event (Keydown)
  #
  setupInput: ->
    that = @
    input = @View._input

    """
    ###
    ### Tab action
    ###
    """
    # e --> Event
    # inputField --> HTML DOM element
    tab = (e, inputField) ->
      e.preventDefault()

      # Determine which tab number this is
      that.__tabCount = if not that.__tabCount then 0 else that.__tabCount
      that.__tabCount = (that.__tabCount + 1) %% 2

      # Fetch Value of the input field
      input = $(inputField).val()

      # Create a command for input text
      command = new GothamGame.Terminal.Command that , input

      # Return if this is not an valid command
      if not command.isCommand()
        return

      # Return if the tabCount is not 1 (Only want to do tab action every second tab)
      if that.__tabCount !=  1
        return


      # Find files in filesystem by that name
      files = that.filesystem.findFiles command.arguments

      # Create graphical representation of files
      # Remove dir extension
      output = ""
      for child in files
        ext = if child.extension != "dir" then ".#{child.extension}" else ""
        child.fullname = "#{child.name}#{ext}"
        output += "#{child.fullname}    "

      # If there is only 1 match, autocomplete it
      if files.length == 1
        $(inputField).val "#{command.command} #{files[0].fullname}"
      else if files.length > 1
        that.console.add output
        that.console.redraw()




    # Action when Enter is hit
    enter = (e, obj) ->
      val = $(obj).val();
      $(obj).val("")

      that.parseInput val

    # Action when Arrows up/down is hit
    arrow = (e, obj) ->
      isUp = e.which is TerminalController.KEYCODE.ARROW_UP


      historyPointer = if isUp then that.console.incrementHistoryPointer(-1) else that.console.incrementHistoryPointer(1)
      historyItem = that.console.getHistoryAt historyPointer

      $(obj).val historyItem.command + " " +historyItem.arguments.join(" ")




    input.on 'keydown', (e) ->
      keycode = e.which

      if keycode is TerminalController.KEYCODE.ENTER then enter(e, @)
      if keycode is TerminalController.KEYCODE.TAB then tab(e, @) else that.__tabCount = 0
      if keycode is TerminalController.KEYCODE.ARROW_UP or keycode is TerminalController.KEYCODE.ARROW_DOWN then arrow(e, @)

  parseInput: (input) ->

    # Create a command object
    command = new GothamGame.Terminal.Command @, input

    # Add To console
    @console.add "#{@identity.first_name}@#{@host.machine_name}:~# #{command.getInput()}"

    # Add command to console.history
    @console.addHistory command

    # If not an valid command
    if not command.isCommand()
      @console.add "#{command.getInput()}: command not found"
    else
      # Execute Command
      command.execute()


  toggle: ->

    if $(@View.terminal_frame).is(":visible")
      @View.terminal_frame.hide()
    else
      $(".terminal_frame").hide()
      @View.terminal_frame.show()


  show: () ->
    $(".terminal_frame").hide()
    @View.terminal_frame.show()
  hide: () ->
    @View.terminal_frame.hide()


  setHost: (host) ->
    @host = host

  setIdentity: (identity) ->
    @identity = identity

  setNetwork: (network) ->
    @network = network

  # Output the boot sequence of the virtual machine
  #
  boot: ->
    @console.addArray [
      "Welcome to GothOS 1.0 (GNU/Linux 3.16.0-23-generic x86_64)",
      ""
      " * Documentation:  https://help.gotham.no/",
      "",
      "  System information as of #{new Date()}",
      "",
      "  System load:  0.18                Processes:           162",
      "  Usage of /:   16.6% of 157.36GB   Users logged in:     0",
      "  Memory usage: 48%                 IP address for eth0: #{@host.ip}",
      "  Swap usage:   0%                  IP address for eth1: 10.131.240.142",
      "",
      "",
      "23 packages can be updated.",
      "19 updates are security updates.",
      "",
      "Last login: Fri Mar 20 17:09:49 2015 from grm-studby-128-39-148-43.studby.uia.no"
    ]
    @console.redraw()












module.exports = TerminalController