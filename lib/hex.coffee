fs = require 'fs-plus'
HexView = null

module.exports =
  configDefaults:
    bytesPerLine: 16

  activate: ->
    atom.workspace.registerOpener (uriToOpen) ->
      pathname = uriToOpen.replace('hex://', '')
      return unless uriToOpen.substr(0, 4) is 'hex:'

      HexView ?= require './hex-view'
      new HexView(filePath: pathname)

    atom.workspaceView.command 'hex:view', ->
      if atom.workspace.activePaneItem?
        uri = atom.workspace.activePaneItem.getUri()
        if uri and fs.existsSync(uri)
          atom.workspaceView.open("hex://#{uri}")
        else
          console.warn "File (#{uri}) does not exists"
