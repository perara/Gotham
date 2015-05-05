

###*
# View for gothsshark. This is empty as the View is actually located in the index.html (Because of Angular datababinding (TODO)
# @class GothsharkView
# @module Frontend.View
# @namespace GothamGame.View
# @extends Gotham.Pattern.MVC.View
###
class GothsharkView extends Gotham.Pattern.MVC.View

  constructor: ->
    super

  """
    <div class="navbar navbar-default navbar-sm">
        <div class="navbar-header"><a class="navbar-brand" href="#">GothShark</a>
            <a class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="#">File</a></li>
                <li><a href="#">Edit</a></li>
                <li><a href="#">View</a></li>
                <li><a href="#">Help</a></li>
            </ul>
        </div>

        <div class="navbar-collapse collapse table-striped">

            <form class="form-inline">
                <div class="form-group" style="padding:2px;">
                    Filter:
                    <input type="text" class="form-control input-sm" style="border-radius:0px;" id="filter">
                    | Node: {{node.name}} | IP: {{node.Network.external_ip_v4}}
                </div>
            </form>
        </div>
    </div>
  """
  create: ->

    @gothshark_frame = $('<div\>',
      {
        id: "gothshark_frame"
        class: "gothshark_frame"
        style: """
          background-color: whitesmoke;
          background-image: url('http://128.39.148.43:9001/assets/img/gothshark-logo.png');
          background-repeat: no-repeat;
          background-position: 50% 60%;
          position: fixed;
          /*display: none;*/
          display: block;
          top: 47%;
          left: 20%;
          width: 60%;
          height: 52%;
        """
      })

    @gothshark_frame.append("""
     <div class="navbar navbar-default navbar-sm">
          <div class="navbar-header"><a class="navbar-brand" href="#">GothShark</a>
              <a class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
              </a>
          </div>
          <div class="navbar-collapse collapse">
              <ul class="nav navbar-nav">
                  <li class="active"><a href="#">File</a></li>
                  <li><a href="#">Edit</a></li>
                  <li><a href="#">View</a></li>
                  <li><a href="#">Help</a></li>
              </ul>
          </div>

          <div class="navbar-collapse collapse table-striped">

              <form class="form-inline">
                  <div class="form-group" style="padding:2px;">
                      Filter:
                      <input type="text" class="form-control input-sm gothshark-filter" style="border-radius:0px;" id="filter">
                      | Node: <div id="node-name" style="display: inline;">A node name</div> | IP: <div id="node-ip" style="display: inline;">192.168.10.101</div>
                  </div>
              </form>
          </div>
      </div>
      <table class="table table-condensed gothshark-table">
          <thead>
          <tr>
              <td>No.</td>
              <td>Time</td>
              <td>Source</td>
              <td>Destination</td>
              <td>Protocol</td>
              <td>Length</td>
              <td>Info</td>
          </tr>
          </thead>

          <tbody>

          <tr class="info">
              <td>1388</td>
              <td>2.05082800</td>
              <td>192.168.1.18</td>
              <td>128.39.149.110</td>
              <td>UDP</td>
              <td>1066</td>
              <td>Source port: 62262  Destination port: 63446</td>
          </tr>

          <tr class="info">
              <td>1389</td>
              <td>2.05082800</td>
              <td>192.168.1.18</td>
              <td>128.39.149.110</td>
              <td>UDP</td>
              <td>1066</td>
              <td>Source port: 62262  Destination port: 63446</td>
          </tr>
          </tbody>
      </table>
    """)


    $("#node-details").append(@gothshark_frame)


    $(window).resize ->

      newHeight = $(this).height() * ($(".gothshark-table").height() / 100) + 20
      $(".dataTables_scrollBody").height(newHeight)

    table = @table = $(".gothshark-table").DataTable({
      "paging":   false,
      "ordering": true,
      "info":     false,
      bFilter: true,
      bInfo: false
      "dom": "frtiS",
      "scrollY": "400px"
    })

    $('.gothshark-filter').keyup ->
      table.search( this.value )
      table.draw()



  ###*
  # Adds a packet to the table,
  # @method addPacket
  # @param data {Object} The data object
  # @param data.number {Number} The packet number
  # @param data.time {String} The packet time (arrival)
  # @param data.source {String} The source address of the packet
  # @param data.dest {String} The destination address of the packet
  # @param data.protocol {String} The protocol of the packet (TCP, ICMP ,ect)
  # @param data.length {Number} Length in bytes of the packet
  # @param data.info {String} The information string
  ###
  addPacket: (data) ->
    @table.row.add([data.number, data.time, data.source, data.dest, data.protocol, data.length, data.info]).draw();


  ###*
  # Clears the table data
  # @method clearTable
  ###
  clearTable: ->
    @table.clear()
    @table.draw()

module.exports = GothsharkView