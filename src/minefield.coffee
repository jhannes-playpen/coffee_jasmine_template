
class exports.Minefield
  constructor: (args) ->
    @mines = args.mines
    @explored = @toggleExplored args.explored
  hints: () ->
    ((@hint(row,col) for col in @cols()).join("") for row in @rows())
  hint: (row,col)->
    return "?" unless @explored[row][col]
    return "*" if @hasMine(row,col)
    minecount = 0
    for r in [row-1..row+1]
      for c in [col-1..col+1]
        minecount++ if @hasMine(r,c)    
    minecount
    
  hasMine: (row,col) ->
    return false unless 0 <= row < @mines.length
    @mines[row][col] == '*'
    
  triggered: (row,col) ->
    @triggeredMine and @triggeredMine[0] == row and @triggeredMine[1] == col

  rows: -> [0...@mines.length]
  
  cols: -> [0...@mines[0].length]
  
  html: ->
    ("<tr>#{@htmlTd(row,col) for col in @cols()}</tr>" for row in @rows()).join("")

  htmlTd: (row,col) ->
    cellClass = if @hasMine(row,col) then 'mine' else ('mines-' + @hint(row,col))
    cellClass += " triggered" if @triggered(row,col)
      
    "<td data-row=\"#{row}\" data-col=\"#{col}\" " +
      "class=\"#{cellClass}\">#{@hint(row,col)}</td>"

  explore: (row,col) ->
    @explored[row][col] = true
    if @hasMine(row,col)
      @reveal() 
      @triggeredMine = [row,col]
    if @onlyMinesUnexplored()
      @reveal()
  
  reveal: -> @toggleExplored true
  
  toggleExplored: (explored) ->
    @explored = ((explored for col in @cols()) for row in @rows())
    
  onlyMinesUnexplored: ->
    for row in @rows()
      for col in @cols()
        return false unless @hasMine(row,col) or @explored[row][col]
    true