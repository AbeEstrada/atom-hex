fs = require 'fs-plus'
HexView = null

module.exports =
  configDefaults:
    bytesPerLine: 16

  activate: ->
    atom.commands.add 'atom-workspace', 'hex:view', => createView()
    @openerDisposable = atom.workspace.addOpener(openURI)

  deactivate: ->
    @openerDisposable.dispose()

openURI = (uriToOpen) ->
  pathname = uriToOpen.replace 'hex://', ''
  return unless uriToOpen.substr(0, 4) is 'hex:'

  HexView ?= require './hex-view'
  new HexView(filePath: pathname)

createView = ->
  paneItem = atom.workspaceView.getActivePaneItem()
  if paneItem?
    filePath = paneItem.file.path
    if fs.isFileSync(filePath)
      atom.workspace.open "hex://#{filePath}"
    else
      console.warn "File (#{filePath}) does not exists"
