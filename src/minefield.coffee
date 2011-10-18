
class exports.Minefield
  constructor: (@mines)->
    @hints_ = ((0 for column in mineRow) for mineRow in @mines)
    @explored_ = ((false for column in mineRow) for mineRow in @mines)
    @exploded_ = []
    for row in [0...@mines.length]
      for column in [0...@mines[row].length]
        if @hasMine_(row,column)
          @hints_[row][column] = '*'
          @indicateNeighbouringMines_(row,column)
          
  indicateNeighbouringMines_:(row,column)->
    neighbours = [[-1,-1],[-1,0],[-1,+1],[0,-1],[0,+1],[+1,-1],[+1,0],[+1,+1]]
    @indicateNeighbouringMine_(row+cell[0],column+cell[1]) for cell in neighbours

  indicateNeighbouringMine_:(row,column) -> 
    if 0 <= row < @mines.length and not @hasMine_(row,column)
      @hints_[row][column] += 1

  hasMine_:(row,column) -> @mines[row][column] == '*'

  hints: ()->
    (@hintRow_(row) for row in [0...@mines.length])

  hintRow_: (row)->(@hints_[row][column] for column in [0...@mines[row].length]).join("")

  html: ()->
    (@htmlRow_(row) for row in [0...@mines.length]).join("")
  htmlRow_: (row)->
    "<tr>" + (@htmlCell_(row,column) for column in [0...@mines[row].length]).join("") + "</tr>"
  cellClass_: (row,column)->
    return "unknown" unless @explored_[row][column]
    return "mine triggered" if @exploded_[0] == row and @exploded_[1] == column
    return "mine" if @hasMine_(row,column)
    "mines-#{@hints_[row][column]}"
  cellText_: (row,column)->
    return "?" unless @explored_[row][column]
    return "*" if @hasMine_(row,column)
    return @hints_[row][column]
  htmlCell_: (row,column)->
    cellAttr = "data-cell='#{row},#{column}'"
    "<td class='#{@cellClass_(row,column)}' #{cellAttr}>#{@cellText_(row,column)}</td>"
    
  explore: (coordinates)->
    @exploreCell_( (parseInt(i) for i in coordinates.split(",")) )
    
  allSafeSquaresExplored_:()->
    for row in [0...@mines.length]
      for column in [0...@mines[row].length]
        return false unless @hasMine_(row,column) or @explored_[row][column]
    return true

  exploreCell_:(coordinates)->
    @explored_[coordinates[0]][coordinates[1]] = true
    if @hasMine_(coordinates[0],coordinates[1])
      @exploded_ = [coordinates[0],coordinates[1]]
      @explored_ = ((true for column in mineRow) for mineRow in @mines)
    else if @allSafeSquaresExplored_()
      @explored_ = ((true for column in mineRow) for mineRow in @mines)
      @victory = true
