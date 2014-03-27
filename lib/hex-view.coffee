path = require 'path'
fs = require 'fs-plus'
entities = require("entities")
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
    stream = fs.createReadStream(filePath)
    stream.on 'data', (chunk) =>
      @hex chunk

  getPath: -> @filePath

  getUri: -> @filePath

  getTitle: -> "#{path.basename(@getPath())} Hex"

  # Based on "node-hex" by Gabriel Llamas
  # https://github.com/gagle/node-hex

  hex: (buffer) =>
    rows = Math.ceil(buffer.length / 16)
    last = buffer.length % 16 or 16
    offsetLength = buffer.length.toString(16).length
    offsetLength = 6 if offsetLength < 6

    offset = "Offset:"
    hex = ""
    ascii = ""

    i = 0
    while i < 16
      offset += " #{zero(i, 2)}"
      i++

    b = 0
    lastBytes = undefined
    v = undefined
    i = 0

    while i < rows
      hex += "#{zero(b, offsetLength)}:"
      lastBytes = (if i is rows - 1 then last else 16)

      j = 0
      while j < lastBytes
        hex += " #{zero(buffer[b], 2)}"
        b++
        j++

      b -= lastBytes

      j = 0
      while j < lastBytes
        v = buffer[b]
        if (v > 31 and v < 127) or v > 159
          ascii += entities.encodeHTML(String.fromCharCode(v))
        else
          ascii += "."
        b++
        j++

      hex += "<br>"
      ascii += "<br>"
      i++

    @hexDump.append "<header>#{offset}</header>"
    @hexDump.append "<div class=\"hex\">#{hex}</div>"
    @hexDump.append "<div class=\"ascii\">#{ascii}</div>"

zero = (n, max) ->
  n = n.toString(16).toUpperCase()
  n = "0#{n}" while n.length < max
  n
