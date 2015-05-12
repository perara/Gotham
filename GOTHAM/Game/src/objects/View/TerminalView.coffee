

###*
# The terminal view shows / displays the terminal. These are created with JQUERY and appended to the index file
# @class TerminalView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class TerminalView extends Gotham.Pattern.MVC.View

  TerminalView.count = 0
  constructor: ->
    super

    @name = null
    TerminalView.count += 1

    @id = JSON.parse(JSON.stringify("#{TerminalView.count}"))

    @_console = undefined
    @_input = undefined
    @_console_window = undefined

  create: ->
    @create_terminal()

  # Sets the console object
  #
  # @param console {Console} The console object
  #
  setConsole: (console) ->
    @_console = console
    return @_console

  # Redraws text in the console
  #
  redraw: ->
    $(@_console_window).html(@_console.all().join("<br/>"))
    objDiv = document.getElementById($(@_console_window).attr("id"));
    objDiv.scrollTop = objDiv.scrollHeight;


  create_terminal: ->
    selection = '-moz-user-select: none; -webkit-user-select: none; -ms-user-select:none; user-select:none;-o-user-select:none;'


    terminalCount = $(".terminal_frame").length


    @terminal_frame = terminal_frame = $('<div\>',
      {
        id: "terminal_frame_#{terminalCount}"
        class: "terminal_frame"
        style: """
          width: 700px;
          height: 350px;
          background-color: red;
          position: fixed;
          top: 27%;
          left: 40%;
        """
      })


    terminal_title_frame = $('<div\>',
      {
        id: "terminal_title_frame_#{terminalCount}"
        style: """
          width: 100%;
          height: 5%;
          min-height: 25px;
          background-color: black;
          border-bottom: 1px solid gray;
          position: relative;
          top: 0px;
          left: 0px;
          #{selection}
        """
      })

    terminal_title_text = $('<div\>',
      {
        id: "terminal_title_text_#{terminalCount}"
        style: """
          text-align: center;
          color: white;
          position: relative;
          display: inline-block;
          width:90%;
          #{selection}
        """
        text: "Terminal x64"
      })


    terminal_title_close = $('<div\>',
      {
        id: "terminal_title_close#{terminalCount}"
        style: """
          text-align: center;
          color: white;
          position: relative;
          display: inline-block;
          width:5%;
          cursor: pointer;
          #{selection}
        """
        text: "X"
      })
    $(terminal_title_close).on 'click', ->
      $(terminal_frame).hide();



    terminal_console_frame = $('<div\>',
      {
        id: "terminal_console_frame_#{terminalCount}"
        style: """
          width: 100%;
          height: 85%;
          border-bottom: 1px solid gray;
          position: relative;
          top: 0px;
          left: 0px;
        """
      })


    @_console_window = terminal_console_content = $('<div\>',
      {
        id: "terminal_console_frame_content_#{terminalCount}"
        style: """
          width: 100%;
          height: 100%;
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
          white-space:pre;
          word-wrap: break-word;
        """
        text: ""
      })

    terminal_input_frame = $('<div\>',
      {
        id: "terminal_input_frame_#{terminalCount}"
        style: """
          width: 100%;
          height: 10%;
          background-color: gray;
          position: relative;
        """
      })


    @_input = terminal_input_field = $('<input\>',
      {
        type: "text"
        id: "terminal_input_field_#{terminalCount}"
        style: """
          width: 100%;
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


    # Minimize button
    terminal_title_minimize = $('<div\>',
      {
        id: "terminal_title_close#{terminalCount}"
        style: """
          text-align: center;
          color: white;
          position: relative;
          display: inline-block;
          width:5%;
          cursor: pointer;
          #{selection}
        """
        text: "_"
      })
    minimized = false
    oldHeight = 0
    terminal_title_minimize.on 'click', ->
      minimized = !minimized

      if minimized
        $(terminal_console_frame).hide()
        $(terminal_input_frame).hide()
        oldHeight = $(terminal_frame).css("height")
        $(terminal_title_minimize).text("+")
        $(terminal_frame).css("height", "auto")
      else
        $(terminal_console_frame).show()
        $(terminal_input_frame).show()
        $(terminal_title_minimize).text("_")
        $(terminal_frame).css("height", oldHeight)







    $(terminal_frame).append(terminal_title_frame)
    $(terminal_title_frame).append(terminal_title_text)
    $(terminal_title_frame).append(terminal_title_minimize)
    $(terminal_title_frame).append(terminal_title_close)

    $(terminal_frame).append(terminal_console_frame)
    $(terminal_console_frame).append(terminal_console_content)

    $(terminal_frame).append(terminal_input_frame)
    $(terminal_input_frame).append(terminal_input_field)


    $(terminal_frame).draggable({
      handle: terminal_title_frame
      drag: (e, ui) ->
        ui.position.top = Math.max(0, ui.position.top );
        ui.position.left = Math.max(0, ui.position.left );

        ui.position.top = Math.min($(window).height() - $(@).height(), ui.position.top );
        ui.position.left = Math.min($(window).width() - $(@).width(), ui.position.left );
    })
    $(terminal_frame).resizable();

    $("body").append(@terminal_frame);



    @terminal_frame.hide();







module.exports = TerminalView