class Minefield
  constructor: (args)->
    @mines = args.mines
    @explored = ((args.explored for col in @cols()) for row in @rows())

  hints: -> ((@hint(row,col) for col in @cols()).join("") for row in @rows())
  hint: (row,col)->
    return "?" unless @explored[row][col]
    return "*" if @hasMine(row,col)
    count = 0
    count++ if @hasMine(row-1,col-1)
    count++ if @hasMine(row-1,col)
    count++ if @hasMine(row-1,col+1)
    count++ if @hasMine(row,col-1)
    count++ if @hasMine(row,col+1)
    count++ if @hasMine(row+1,col-1)
    count++ if @hasMine(row+1,col)
    count++ if @hasMine(row+1,col+1)
    return count

  explore: (row,col)->
    @explored[row][col] = true
    if (@hasMine(row,col))
      @explored = ((true for col in @cols()) for row in @rows())

  hasMine: (row,col) ->
    0 <= row < @mines.length && @mines[row][col] == "*"
  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]

  html: ->
    (@tr(row) for row in @rows()).join("")
  tr: (row)->
    "<tr>" + (@td(row,col) for col in @cols()).join("") + "</tr>"
  td: (row,col)->
    hint = hint || @hint(row,col)
    "<td class='#{@tdClass(hint)}' data-row='#{row}' data-col='#{col}'>#{hint}</td>"
  tdClass: (hint)->
    return "mine" if hint == '*'
    return "unknown" if hint == '?'
    return "mines-#{hint}"

exports.Minefield = Minefield
