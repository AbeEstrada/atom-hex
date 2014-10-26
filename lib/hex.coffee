fs = require 'fs-plus'

module.exports =
  configDefaults:
    bytesPerLine: 16

  HexView: null

  activate: ->
    atom.workspace.registerOpener @openUri
    atom.workspaceView.command 'hex:view', => @createView()

  deactivate: ->
    atom.workspace.unregisterOpener @openUri

  openUri: (uriToOpen) ->
    pathname = uriToOpen.replace 'hex://', ''
    return unless uriToOpen.substr(0, 4) is 'hex:'

    @HexView ?= require './hex-view'
    new HexView(filePath: pathname)

  createView: ->
    if atom.workspace.activePaneItem?
      uri = atom.workspace.activePaneItem.getUri()
      if uri and fs.existsSync(uri)
        atom.workspaceView.open "hex://#{uri}"
      else
        console.warn "File (#{uri}) does not exists"
