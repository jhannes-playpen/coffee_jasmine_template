class Minefield
  constructor: (args) ->
    @mines = args.mines
    @explored = ((args.explored for col in @cols()) for row in @rows())
  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]

  hint: (row,col)->
    return '?' unless @explored[row][col]
    return "*" if @hasMine(row,col)
    count = 0
    for r in [row-1..row+1]
      for c in [col-1..col+1]
        count++ if @hasMine(r,c)
    count

  hasMine: (row,col) -> 
    return false unless 0 <= row < @mines.length
    @mines[row][col] == '*'
  
  hints: () -> ((@hint(row,col) for col in @cols()).join('') for row in @rows())
  
  explore: (row,col) ->
    @explored[row][col] = true


exports.Minefield = Minefield
