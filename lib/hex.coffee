fs = require 'fs-plus'
HexView = null

module.exports =
  config:
    bytesPerLine:
      type: 'integer'
      default: 16
      minimum: 1

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
  paneItem = atom.workspace.getActivePaneItem()
  filePath = paneItem.getPath()
  if paneItem and fs.isFileSync(filePath)
    atom.workspace.open "hex://#{filePath}"
  else
    console.warn "File (#{filePath}) does not exists"
