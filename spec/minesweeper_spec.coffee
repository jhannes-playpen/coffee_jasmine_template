describe "Explored Minefield", ->
  expectHints = (mines)->expect(new exports.Minefield(mines:mines,explored:true).hints())

  it "shows empty cells", ->
    expectHints(["...","..."]).toEqual(["000","000"])
  it "shows minefield size", ->
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
    expectHints(["....","...."]).toEqual(["0000","0000"])
  it "shows mines", ->
    expectHints(["**"]).toEqual(["**"])
  it "detects mine left of cell", ->
    expectHints(["*.."]).toEqual(["*10"])
  it "detects mine right of cell", ->
    expectHints(["..*"]).toEqual(["01*"])
  it "detects mine above cell", ->
    expectHints(["*",".","."]).toEqual(["*","1","0"])
  it "detects mine below cell", ->
    expectHints([".",".","*"]).toEqual(["0","1","*"])
  it "detects mine around cell", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
  it "counts mines around cell", ->
    expectHints(["***","*.*","***"]).toEqual(["***","*8*","***"])

describe "Exploring minefield", ->
  minefield = null
  beforeEach ->
    minefield = new exports.Minefield(mines:["....","..**"], explored:false)
  it "hides unexplored cells", ->
    expect(minefield.hints()).toEqual(["????","????"])
  it "shows explored field", ->
    minefield.explore(0,1)
    expect(minefield.hints()).toEqual(["?1??","????"])
  it "shows minefield when mine is triggered", ->
    minefield.explore(1,2)
    expect(minefield.hints()).toEqual(["0122","01!*"])
  it "shows minefield when all nonmines are explored", ->
    minefield.explore(row,col) for [row,col] in [[0,0],[0,1],[0,2],[0,3],[1,0],[1,1]]
    expect(minefield.hints()).toEqual(["0122","01**"])