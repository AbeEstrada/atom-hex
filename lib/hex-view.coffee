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
    fs.readFile filePath, (error, content) =>
      if error?
        console.error(error)
      else
        @hex(content)

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

    s = "<div class=\"hex-row\"><div class=\"hex-column\">Offset"
    s += " " while s.length < offsetLength
    s = "#{s}</div><div class=\"hex-column\">"

    i = 0
    while i < 16
      s += " #{zero(i, 2)}"
      i++

    s += "</div></div>"

    b = 0
    lastBytes = undefined
    v = undefined
    i = 0

    while i < rows
      s += "<div class=\"hex-row\"><div class=\"hex-column\">"
      s += "#{zero(b, offsetLength)}</div><div class=\"hex-column\">"
      lastBytes = (if i is rows - 1 then last else 16)

      j = 0
      while j < lastBytes
        s += " #{zero(buffer[b], 2)}"
        b++
        j++

      b -= lastBytes
      s += "</div><div class=\"hex-column\">"

      j = 0
      while j < lastBytes
        v = buffer[b]
        if (v > 31 and v < 127) or v > 159
          s += entities.encodeHTML(String.fromCharCode(v))
        else
          s += "."
        b++
        j++

      s += "</div></div>"
      i++

    @hexDump.append s

zero = (n, max) ->
  n = n.toString(16).toUpperCase()
  n = "0#{n}" while n.length < max
  n
