class Minefield
  constructor: (args) ->
    @mines = args.mines
  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]
  hint: (row,col)-> 0


exports.Minefield = Minefield
