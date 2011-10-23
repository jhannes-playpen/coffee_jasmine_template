
class exports.Minefield
  constructor: (args)->
    @_mines = args.mines
    @_explored = ((args.explored for c in @_columns()) for r in @_rows())
    @_trippedMine = []

  hints: ->
    (@_row(row) for row in @_rows())
  explore: (row,column) ->
    @_explored[row][column] = true
    if @_hasMine(row,column)
      @_revealMinefield()
      @_trippedMine = [parseInt(row),parseInt(column)]
    for [r,c] in @_cells()
      return unless @_explored[r][c] or @_hasMine(r,c)
    @_revealMinefield()
  renderHtml: ->
    (@_renderTR(row) for row in @_rows()).join("")
  _renderTR: (r)->
    "<tr>" + (@_renderTD(r,c) for c in @_columns()).join("") + "</tr>"
  _renderTD: (r,c,value)->
    value ||= @_cell(r,c)
    "<td data-row='#{r}' data-column='#{c}' " +
      "class='#{@_cellClass(value)}'>#{value}</td>"
  _cellClass: (value)->
    return "unexplored" if value == '?'
    return "triggered mine" if value == '!'
    return "mine" if value == '*'
    return "mines-#{value}"

  _revealMinefield: ->
    for [r,c] in @_cells()
      @_explored[r][c] = true

  _cells: ->
    result = []
    for r in @_rows()
      for c in @_columns()
        result.push [r,c]
    result
  _row: (row) ->
    (@_cell(row,column) for column in @_columns()).join("")
  _cell: (row,column)->
    return "?" unless @_explored[row][column]
    return "!" if row == @_trippedMine[0] and column == @_trippedMine[1]
    return "*" if @_hasMine(row,column)
    neighbours = [
      [row-1,column-1],[row-1,column],[row-1,column+1],
      [row,column-1],[row,column+1],
      [row+1,column-1],[row+1,column],[row+1,column+1]
      ]
    result = 0
    for [r,c] in neighbours
      result++ if @_hasMine(r,c)
    result

  _hasMine: (row,column) ->
    return false unless 0 <= row < @_mines.length
    @_mines[row][column] == "*"
  _columns: -> [0...@_mines[0].length]
  _rows: -> [0...@_mines.length]

