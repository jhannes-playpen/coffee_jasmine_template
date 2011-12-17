class exports.Minefield
  constructor: (args) ->
    @mines = args.mines

  hints: ->
    ((@hint(row,col) for col in @cols()).join("")  for row in @rows())
  
  cols: -> [0...@mines[0].length]
  
  rows: -> [0...@mines.length]
  
  hint: (row,col)-> 
    return "*" if @hasMine(row,col)
    count = 0
    for r in [row-1..row+1]
      for c in [col-1..col+1]
        count++ if @hasMine(r,c)
    count
    
  hasMine: (row,col) ->
    return false unless 0 <= row < @mines.length
    @mines[row][col] == "*"
