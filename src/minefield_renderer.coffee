class MinefieldRenderer
  constructor: (@minefield) ->

  html: ->
    (@tr(row) for row in @minefield.rows()).join("")
  tr: (row)->
    "<tr>" + (@td(row,col) for col in @minefield.cols()) + "</tr>"
  td: (row,col)->
    val = @minefield.hint(row,col)
    "<td class='#{@tdClass(val)}' data-row='#{row}' data-col='#{col}'>#{val}</td>"
  tdClass: (value)->
    return "unexplored" if value == '?'
    return "triggered" if value == '!'
    return "mine" if value == '*'
    return "mines-#{value}"


exports.MinefieldRenderer = MinefieldRenderer
