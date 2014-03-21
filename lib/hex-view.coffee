path = require 'path'
fs = require 'fs-plus'
hex = require './hex-helper'
{$, ScrollView} = require 'atom'

module.exports =
class HexView extends ScrollView
  @content: ->
    @div class: 'hex-view padded pane-item', tabindex: -1, =>
      @div class: 'hex-dump', outlet: 'hexDump'

  initialize: ({@filePath}) =>
    super

  afterAttach: ->
    @hexFile(@filePath)

    $('.hex-dump').css
      'font-family': atom.config.get('editor.fontFamily')
      'font-size': atom.config.get('editor.fontSize')

  hexFile: (filePath) ->
    fs.readFile filePath, (error, content) =>
      if error?
        console.error(error)
      else
        @hexDump.html hex(content)

  getPath: -> @filePath

  getUri: -> @filePath

  getTitle: -> "#{path.basename(@getPath())} Hex"
