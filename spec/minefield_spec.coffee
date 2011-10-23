describe 'Minefield hints', ->
  expectHints = (mines)->
    minefield = new exports.Minefield(mines:mines,explored:true)
    expect(minefield.hints())

  it "shows empty cells", ->
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
  it "shows field dimensions", ->
    expectHints(["...","..."]).toEqual(["000","000"])
    expectHints(["....","...."]).toEqual(["0000","0000"])
  it "shows mines", ->
    expectHints(["**","**"]).toEqual(["**","**"])
  it "shows hints for neighbour mines", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
  it "counts neighbouring mines", ->
    expectHints(["***","*.*","***"]).toEqual(["***","*8*","***"])

describe "Exploring minefield", ->
  minefield = null
  beforeEach ->
    minefield = new exports.Minefield mines:["**..","...."],explored:false
  it "shows unexplored fields", ->
    expect(minefield.hints()).toEqual(["????","????"])
  it "shows explored cells", ->
    minefield.explore("0","3")
    expect(minefield.hints()).toEqual(["???0","????"])
  it "show minefield when nonmines are explored", ->
    minefield.explore(r,c) for [r,c] in [[0,2],[0,3],[1,0],[1,1],[1,2],[1,3]]
    expect(minefield.hints()).toEqual(["**10","2210"])
  it "shows minefield when mine explodes", ->
    minefield.explore("0","0")
    expect(minefield.hints()).toEqual(["!*10","2210"])

describe "Rendering of minefield", ->
  minefield = null
  beforeEach ->
    minefield = new exports.Minefield mines:["**..","...."],explored:false

  it "shows minefield as HTML", ->
    expect(minefield.renderHtml()).toMatch(/<tr>.*<\/tr><tr>.*<\/tr>/)
  it "shows minefield row", ->
    expect(minefield._renderTR(1)).toMatch(/<tr><td.*<td.*<td.*<td.*><\/tr>/)
  it "shows minefield cell", ->
    expect(minefield._renderTD(1,2)).
      toEqual("<td data-row='1' data-column='2' class='unexplored'>?</td>")
    expect(minefield._renderTD(0,3,'0')).
      toEqual("<td data-row='0' data-column='3' class='mines-0'>0</td>")
  it "shows minefield class", ->
    expect(minefield._cellClass('*')).toEqual("mine")
    expect(minefield._cellClass('!')).toEqual("triggered mine")
    expect(minefield._cellClass('?')).toEqual("unexplored")
    expect(minefield._cellClass('3')).toEqual("mines-3")

describe "Utilities", ->
  it "calculate cells", ->
    minefield = new exports.Minefield(mines:["...","..."])
    expect(minefield._rows()).toEqual([0...2])
    expect(minefield._columns()).toEqual([0...3])
    expect(minefield._cells()).
      toEqual([[0,0],[0,1],[0,2],[1,0],[1,1],[1,2]])