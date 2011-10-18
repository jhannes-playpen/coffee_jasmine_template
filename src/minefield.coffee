
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

  cell_:(x,y) ->
    if !(@exploded_ < [x,y] || @exploded_ > [x,y]) then return "!"
    if @explored_[x][y] then @hints_[x][y] else "?"

  hints:()->(@hintRow_(row) for row in [0...@mines.length])
  hintRow_: (row)->(@cell_(row,column) for column in [0...@mines[row].length]).join("")

  html: ()->
    (@htmlRow_(row) for row in [0...@mines.length]).join("")
  htmlRow_: (x)->
    "<tr>" + (@htmlCell_(x,y,@cell_(x,y)) for y in [0...@mines[x].length]).join("") + "</tr>"
  cellClass_: (value)->
    switch value
      when "?" then return "unknown"
      when "!" then return "mine triggered"
      when "*" then return "mine"
      else return "mines-#{value}"
  cellText_: (row,column)->
    return @cell_(row,column)
  htmlCell_: (row,column,value)->
    cellAttr = "data-cell='#{row},#{column}'"
    "<td class='#{@cellClass_(value)}' #{cellAttr}>#{value}</td>"

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
