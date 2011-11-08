Minefield = exports.Minefield

describe "Explored minefield", ->
  expectHints = (mines) ->
    minefield = new Minefield(mines:mines, explored:true)
    expect(minefield.hints())

  it "shows empty mines", ->
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
  it "shows size of minefield", ->
    expectHints(["...","..."]).toEqual(["000","000"])
    expectHints(["....","...."]).toEqual(["0000","0000"])
  it "shows mines", ->
    expectHints(["***","***"]).toEqual(["***","***"])
  it "indicates mines at row start", ->
    expectHints(["*.."]).toEqual(["*10"])
  it "indicates mine at row end", ->
    expectHints(["..*"]).toEqual(["01*"])
  it "indicates mines at col top", ->
    expectHints(["*",".","."]).toEqual(["*","1","0"])
  it "indicates mines at col bottom", ->
    expectHints([".",".","*"]).toEqual(["0","1","*"])
  it "indicates mines at all neighbours", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
  it "counts neighbouring mines", ->
    expectHints(["***","*.*","***"]).toEqual(["***","*8*","***"])

describe "Exploring", ->
  minefield = new Minefield(mines:["**.","..."],explored:false)
  it "shows initial fields as unexplored", ->
    expect(minefield.hints()).toEqual(["???","???"])
  it "shows explored fields", ->
    minefield.explore(1,2)
    expect(minefield.hint(1,2)).not.toEqual("?")
    expect(minefield.hint(0,0)).toEqual("?")
  it "reveals field when mine is stepped on", ->
    minefield.explore(0,0)
    expect(minefield.hint(1,1)).not.toEqual("?")

describe "Minefield as HTML", ->
  minefield = new Minefield(mines:["....","...."])
  it "shows size of field", ->
    expect(minefield.html()).toMatch(/<tr>.*<\/tr><tr>.*<\/tr>/)
    expect(minefield.tr(0)).toMatch(/<tr><td.*<td.*<td.*<\/tr>/)
  it "shows cell position", ->
    expect(minefield.td(1,3)).toMatch(/data-row='1'/)
    expect(minefield.td(1,3)).toMatch(/data-col='3'/)
  it "shows cell class", ->
    expect(minefield.td(1,2, "*")).toMatch("class='mine'")
    expect(minefield.td(1,2, "?")).toMatch("class='unexplored'")
    expect(minefield.td(1,2, "1")).toMatch("class='mines-1'")
    expect(minefield.td(1,2, "4")).toMatch("class='mines-4'")
  it "shows cell value", ->
    expect(minefield.td(1,2,"*")).toMatch(/>*</)
