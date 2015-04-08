

class Mission extends Gotham.Pattern.MVC.View


  constructor ->


  create: ->


  # This view displays a list of available missions, clicking on one of the missions.
  # Interacting with an item in the list opens up another view with mission details
  #
  listView ->

  # This view displays a selected mission, the user is able to select to start such mission type
  missionView ->




module.exports = Mission