url = require 'url'
HexView = null

module.exports =
  activate: ->
    atom.project.registerOpener (uriToOpen) ->
      {protocol, host, pathname} = url.parse(uriToOpen)
      pathname = decodeURI(pathname) if pathname
      return unless protocol is 'hex:'

      HexView ?= require './hex-view'
      new HexView(filePath: pathname)

    atom.workspaceView.command 'hex:view', ->
      if atom.workspace.activePaneItem?
        uri = atom.workspace.activePaneItem.getUri()
        atom.workspaceView.open("hex://#{uri}")
