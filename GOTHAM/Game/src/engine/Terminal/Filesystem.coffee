Terminal = require './Terminal.coffee'


class Filesystem

  constructor: (json) ->

    data = JSON.parse(json.data)

    @_fs = @Parse data
    @_root = @Parse data

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
        ext = if child.extension is "dir" then "" else "."+child.extension
        if filename+ext is _path
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
    return @_fs.children

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


module.exports = Filesystem