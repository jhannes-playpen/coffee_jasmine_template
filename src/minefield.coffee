class Minefield
  constructor: (args)->
    @mines = args.mines
    @explored = ((args.explored for col in @cols()) for row in @rows())
    @killingCell = []

  hints: -> ((@hint(row,col) for col in @cols()).join("") for row in @rows())

  hint: (row,col)->
    return "?" unless @explored[row][col]
    return "!" if @killingCell[0] == row and @killingCell[1] == col
    return "*" if @hasMine(row,col)
    count = 0
    for r in [row-1..row+1]
      for c in [col-1..col+1] when @hasMine(r,c)
        count++
    count

  explore: (row,col) ->
    @explored[row][col] = true
    if @hasMine(row,col)
      @showAll()
      @killingCell = [row,col]
    if @allNonMinesExplored() then @showAll()

  allNonMinesExplored: ->
    for row in @rows()
      for col in @cols() when not (@hasMine(row,col) or @explored[row][col])
        return false
    return true

  showAll: ->
    @explored = ((true for col in @cols()) for row in @rows())

  hasMine: (row,col) ->
    0 <= row < @mines.length and @mines[row][col] == '*'
  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]


exports.Minefield = Minefield
