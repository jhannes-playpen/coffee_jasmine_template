describe "Explored minefield", ->
  expectHints = (mines)->
    expect(new exports.Minefield(mines:mines,explored:true).hints())
  it "shows empty cells", ->
    expectHints(["...","..."]).toEqual(["000","000"])
  it "shows size of minefield", ->
    expectHints(["....","...."]).toEqual(["0000","0000"])
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
  it "shows mines", ->
    expectHints(["**","**"]).toEqual(["**","**"])
  it "detects mine left of cell", ->
    expectHints(["*.."]).toEqual(["*10"])
  it "detects mine right of cell", ->
    expectHints(["..*"]).toEqual(["01*"])
  it "detects mine above", ->
    expectHints(["*",".","."]).toEqual(["*","1","0"])
  it "detects mine below", ->
    expectHints([".",".","*"]).toEqual(["0","1","*"])
  it "detect mines around cell", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
  it "counts mines around cell", ->
    expectHints(["***","*.*","***"]).toEqual(["***","*8*","***"])


describe "Exploring minefield", ->
  minefield = null
  beforeEach ->
    minefield = new exports.Minefield(mines:["....","..**"], explored:false)
  it "hides unexplored cells", ->
    expect(minefield.hints()).toEqual(["????","????"])
  it "shows explored cell", ->
    minefield.explore(0,1)
    expect(minefield.hints()).toEqual(["?1??","????"])
  it "shows whole field when player dies", ->
    minefield.explore(1,3)
    expect(minefield.hints()).toEqual(["0122","01*!"])
  it "shows whole field when player wins", ->
    minefield.explore(row,col) for [row,col] in [[0,0],[0,1],[0,2],[0,3],[1,0],[1,1]]
    expect(minefield.hints()).toEqual(["0122","01**"])
