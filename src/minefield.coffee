class Minefield
  constructor: (args)->
    @mines = args.mines
    @explored = ((args.explored for col in @cols()) for row in @rows())
    @triggered = []
  hints: ()->((@hint(row,col) for col in @cols()).join("") for row in @rows())
  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]

  hint: (row,col)->
    return "?" unless @explored[row][col]
    return "!" if @triggered[0] == row and @triggered[1] == col
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
  hasMine: (row,col)-> 0<=row<@mines.length and @mines[row][col] == '*'
  explore: (row,col)->
    @explored[row][col] = true
    if @hasMine(row,col)
      @explored = ((true for c in @cols()) for r in @rows())
      @triggered = [row,col]
    for row in @rows()
      for col in @cols()
        return unless @hasMine(row,col) or @explored[row][col]
    @explored = ((true for col in @cols()) for row in @rows())




exports.Minefield = Minefield
