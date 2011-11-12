class Minefield
  constructor: (args)->
    @mines = args.mines
    @explored = ((args.explored for col in @cols()) for row in @rows())

  hints: ()->
    ((@hint(row,col) for col in @cols()).join("") for row in @rows())
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
    count
  explore: (row,col) ->
    @explored[row][col] = true
    @showAll() if @hasMine(row,col)
    for row in @rows()
      for col in @cols()
        return unless @hasMine(row,col) or @explored[row][col]
    @showAll()

  showAll: ->
    @explored = ((true for col in @cols()) for row in @rows())

  hasMine: (row,col) -> 0 <= row < @mines.length and @mines[row][col] == '*'

  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]


exports.Minefield = Minefield
