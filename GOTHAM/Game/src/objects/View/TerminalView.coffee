


class TerminalView extends Gotham.Pattern.MVC.View

  constructor: ->
    super

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
  Redraw: ->
    $(@_console_window).html(@_console.all().join("<br/>"))
    objDiv = document.getElementById("terminal_console_frame_content");
    objDiv.scrollTop = objDiv.scrollHeight;


  create_terminal: ->
    selection = '-moz-user-select: none; -webkit-user-select: none; -ms-user-select:none; user-select:none;-o-user-select:none;'

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
          #{selection}
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
          #{selection}
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


    @_console_window = terminal_console_content = $('<div\>',
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


    @_input = terminal_input_field = $('<input\>',
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

    $(terminal_frame).append(terminal_title_frame)
    $(terminal_title_frame).append(terminal_title_text)

    $(terminal_frame).append(terminal_console_frame)
    $(terminal_console_frame).append(terminal_console_content)

    $(terminal_frame).append(terminal_input_frame)
    $(terminal_input_frame).append(terminal_input_field)


    $(terminal_frame).draggable({handle: terminal_title_frame});
    $(terminal_frame).resizable();

    $("body").append(@terminal_frame);
    @terminal_frame.hide();







module.exports = TerminalView