class Minefield
  constructor: (args) ->
    @mines = args.mines
    @explored = ((args.explored for col in @cols()) for row in @rows())
  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]
  
  has_mine:(row,col) ->
    return false unless 0 <= row < @mines.length
    @mines[row][col] == "*"
  
  hint: (row,col)->
    return "?" unless @explored[row][col]
    return "*" if @has_mine(row,col)
    count = 0
    for r in [row-1..row+1]
      for c in [col-1..col+1]
        count++ if @has_mine(r,c)
    count
  
  explore: (row, col) ->
    @explored[row][col] = true
  
  hints: () -> 
    ((@hint(row,col) for col in @cols()).join("") for row in @rows())
  
  

exports.Minefield = Minefield
