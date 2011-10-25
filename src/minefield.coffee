class Minefield
  constructor: (@mines) ->
    @explored = ((false for col in @cols()) for row in @rows())

  show: ->
    ((@cell(row,col) for col in @cols()).join("") for row in @rows())

  cell: (row,col)->
    return "?" unless @explored[row][col]
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

  hasMine: (row,col)-> 0<=row<@mines.length && @mines[row][col] == '*'

  explore: (row,col)->
    @explored[row][col] = true

  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]


exports.Minefield = Minefield
