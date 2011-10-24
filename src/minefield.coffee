class Minefield
  hints: (board) ->
    for row in [0...board.length]
      (@hint(board, row,col) for col in [0...board[row].length]).join("")

  hint: (board,row, col) ->
    c = 0
    return "*" if board[row][col] == "*"
    c++ if board[row-1] and board[row-1][col-1] == "*"
    c++ if board[row-1] and board[row-1][col] == "*"
    c++ if board[row-1] and board[row-1][col+1] == "*"
    c++ if board[row][col-1] == "*"
    c++ if board[row][col+1] == "*"
    c++ if board[row+1] and board[row+1][col-1] == "*"
    c++ if board[row+1] and board[row+1][col] == "*"
    c++ if board[row+1] and board[row+1][col+1] == "*"
    return c

  explore: (board, row, col) ->
    grid = @exposeHint(board, row, col)
    if grid[row][col] == '*'
      @lose(board)
    else if grid.join("").indexOf(".") < 0
      @win(board)
    else
      grid

  exposeHint: (board, row, col)->
    for row_ in [0...board.length]
     (
      (if row == row_ and col == col_
      then @hint(board, row_,col_)
      else board[row_][col_]) for col_ in [0...board[row_].length]
     ).join("")

  win: (board) -> (row.replace /\*/g, "!" for row in @hints(board))
  lose: (board) -> (row.replace /\*/g, "!" for row in @hints(board))

  html: (board) ->
    (for row in [0...board.length]
      @tr(board,row)).join("")
  tr: (board,row) ->
    "<tr>#{(@td board, row, col for col in [0...board[row].length]).join("")}</tr>"
  td: (board, row, col) ->
    hint = board[row][col]
    if hint == "!"
      return "<td data-row='#{row}' data-col='#{col}' class='bang'>*</td>"
    else if hint == "." or hint == "*"
      return "<td data-row='#{row}' data-col='#{col}' class='hidden'>?</td>"
    else
      return "<td data-row='#{row}' data-col='#{col}' class='mines-#{hint}'>#{hint}</td>"

exports.Minefield = Minefield
