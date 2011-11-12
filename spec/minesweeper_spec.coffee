describe "Explored minefield", ->
  expectHints = (mines)->
    expect(new exports.Minefield(mines:mines,explored:true).hints())

  it "shows empty field", ->
    expectHints(["....","...."]).toEqual(["0000","0000"])
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
  it "shows mines", ->
    expectHints(["****","****"]).toEqual(["****","****"])
  it "detects neighbouring mines", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
  it "counts close mines", ->
    expectHints(["***","*.*","***"]).toEqual(["***","*8*","***"])

describe "Explore minefield", ->
  minefield = null
  beforeEach ->
    minefield = new exports.Minefield(mines:["....","..**"], explored:false)
  it "hides unexplored fields", ->
    expect(minefield.hints()).toEqual(["????", "????"])
  it "shows explored fields", ->
    minefield.explore(0,1)
    expect(minefield.hints()).toEqual(["?1??","????"])
  it "shows whole minefield when mine is tripped", ->
    minefield.explore(1,3)
    expect(minefield.hints()).toEqual(["0122","01**"])
  it "shows whole minefield when all non-mines are explored", ->
    minefield.explore(row,col) for [row,col] in [[0,0],[0,1],[0,2],[0,3],[1,0],[1,1]]
    expect(minefield.hints()).toEqual(["0122","01**"])