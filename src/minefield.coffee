class Minefield
  constructor: (args)->@mines = args.mines
  hint: (row,col)-> 0
  rows: -> [0...@mines.length]
  cols: -> [0...@mines[0].length]


exports.Minefield = Minefield
