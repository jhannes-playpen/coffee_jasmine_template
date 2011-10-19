
class exports.Minefield
  constructor: (@mines)->
    @hints_ = ((0 for column in mineRow) for mineRow in @mines)
    @explored_ = ((false for column in mineRow) for mineRow in @mines)
    @exploded_ = []
    for row in [0...@mines.length]
      for column in [0...@mines[row].length]
        if @hasMine_ row,column
          @hints_[row][column] = '*'
          @indicateNeighbouringMines_ row,column

  indicateNeighbouringMines_:(row,column)->
    neighbours = [[-1,-1],[-1,0],[-1,+1],[0,-1],[0,+1],[+1,-1],[+1,0],[+1,+1]]
    @indicateNeighbouringMine_ row+cell[0],column+cell[1] for cell in neighbours
  indicateNeighbouringMine_:(row,column) ->
    if 0 <= row < @mines.length and not @hasMine_ row,column
      @hints_[row][column] += 1

  hasMine_:(row,column) -> @mines[row][column] == '*'

  hints:()->(@hintRow_(row) for row in [0...@hints_.length])
  hintRow_: (row)->(@cell_ row,column for column in [0...@mines[row].length]).join("")
  cell_:(x,y) ->
    if !(@exploded_ < [x,y] || @exploded_ > [x,y]) then return "!"
    if @explored_[x][y] then @hints_[x][y] else "?"

  explore: (coordinates)->
    [row,column] = (parseInt(i) for i in coordinates.split(","))
    @exploreCell_ row,column
  allSafeSquaresExplored_:()->
    for row in [0...@mines.length]
      for column in [0...@mines[row].length]
        return false unless @hasMine_(row,column) or @explored_[row][column]
    return true
  exploreCell_:(row,column)->
    coordinates = [row,column]
    @explored_[row][column] = true
    if @hasMine_ row,column
      @exploded_ = [row,column]
      @explored_ = ((true for column in mineRow) for mineRow in @mines)
    else if @allSafeSquaresExplored_()
      @explored_ = ((true for column in mineRow) for mineRow in @mines)
      @victory = true

  html: (hints)->
    hints ||= @hints()
    (@htmlRow_(hints,row) for row in [0...hints.length]).join("")
  htmlRow_: (hints,x)->
    "<tr>" + (@htmlCell_ x,y,hints[x][y] for y in [0...hints[x].length]).join("") + "</tr>"
  cellClass_: (value)->
    switch value
      when "?" then return "unknown"
      when "!" then return "mine triggered"
      when "*" then return "mine"
      else return "mines-#{value}"
  htmlCell_: (row,column,value)->
    cellAttr = "data-cell='#{row},#{column}'"
    "<td class='#{@cellClass_ value}' #{cellAttr}>#{value}</td>"

