class Minefield
  constructor: (args) ->
    @mines = args.mines
    @explored = ((args.explored for col in @cols()) for row in @rows())
  rows: ->[0...@mines.length]
  cols: ->[0...@mines[0].length]

  hints: -> ((@hint(row,col) for col in @cols()).join("") for row in @rows())
  hint: (row,col) ->
    return "?" unless @explored[row][col]
    return "*" if @isMine(row,col)
    count = 0
    count++ if @isMine(row-1,col-1)
    count++ if @isMine(row-1,col)
    count++ if @isMine(row-1,col+1)
    count++ if @isMine(row,col-1)
    count++ if @isMine(row,col+1)
    count++ if @isMine(row+1,col-1)
    count++ if @isMine(row+1,col)
    count++ if @isMine(row+1,col+1)
    return count
  isMine: (row,col) -> 0 <= row < @mines.length && @mines[row][col] == "*"

  explore: (row,col)->
    @explored[row][col] = true
    if @isMine(row,col)
      @explored = ((true for col in @cols() for row in @rows()))

  html: ->
    (@tr(row) for row in @rows()).join("")
  tr: (row) ->
    "<tr>" + (@td(row,col, @hint(row,col)) for col in @cols()).join("") + "</tr>"
  td: (row,col, hint) ->
    "<td data-row='#{row}' data-col='#{col}' class='#{@tdClass(hint)}'>#{hint}</td>"
  tdClass: (hint) ->
    return "mine" if hint == "*"
    return "unexplored" if hint == "?"
    "mines-#{hint}"

exports.Minefield = Minefield
