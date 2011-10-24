board = new exports.Minefield

describe 'Hints for minefield', ->

  expectHints = (mines, expected) ->
    expect(board.hints(mines)).toEqual expected

  it "shows empty field", ->
    expectHints ["...","...","..."], ["000","000","000"]

  it "shows shape of minefield", ->
    expectHints ["...","..."], ["000","000"]

  it 'shows mines', ->
    expectHints ["***", "***"], ["***", "***"]

  it 'finds mines everywhere', ->
    expectHints ["...", ".*.", "..."], ["111", "1*1", "111"]

  it "counts neighbouring mines", ->
    expectHints ["***","*.*","***"], ["***","*8*","***"]

describe 'Displaying the board', ->
  it "shows explored cells", ->
    expect(board.explore ["..*", "...", ".*."], 0, 1).toEqual [".1*", "...", ".*."]

describe 'When I touch a mine', ->
  it 'blows up in my face', ->
    expect(board.explore ["..*", "...", "..."], 0, 2).toEqual ["01!", "011", "000"]

describe "When I finish the minefield", ->
  it "reveals the rest of mines", ->
    expect(board.explore ["**","**","*."], 2,1).toEqual ["!!","!!","!3"]

describe "Minefield as HTML", ->

  it "shows rows", ->
    expect(board.html(["***","***"])).toMatch(/<tr>.*<\/tr><tr>.*<\/tr>/)

  it "shows cells", ->
    expect(board.tr(["***","***"],1)).toMatch(/<tr><td.*<td.*class.*<td.*<\/tr>/)

  it "shows empty cell content", ->
    expect(board.td(["...","..0"],1,2)).
      toEqual("<td data-row='1' data-col='2' class='mines-0'>0</td>")

  it "shows cell with hint 1", ->
    expect(board.td([".1.","..0"],0,1)).
      toEqual("<td data-row='0' data-col='1' class='mines-1'>1</td>")

  it "shows cell with exploded mine", ->
    expect(board.td(["!"], 0,0)).toEqual("<td data-row='0' data-col='0' class='bang'>*</td>")

  it "hides unexplored cells", ->
    expect(board.td(["."], 0,0)).toEqual("<td data-row='0' data-col='0' class='hidden'>?</td>")
  it "hides unexplored mines", ->
    expect(board.td(["*"], 0,0)).toEqual("<td data-row='0' data-col='0' class='hidden'>?</td>")














