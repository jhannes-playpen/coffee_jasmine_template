describe "Explored minefield", ->
  expectHints = (mines) ->
    minefield = new exports.Minefield(mines:mines, explored:true)
    expect(minefield.hints())

  it "shows empty cells", ->
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
  it "shows size of board", ->
    expectHints(["....","...."]).toEqual(["0000","0000"])
  it "shows mines", ->
    expectHints(["**","**"]).toEqual(["**","**"])
  it "indicate close mines", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
  it "counts mines", ->
    expectHints(["***","*.*","***"]).toEqual(["***","*8*","***"])


describe "Exploration of minefield", ->
  minefield = new exports.Minefield(mines:["....","..**"], explored:false)
  it "hides all mines initially", ->
    expect(minefield.hints()).toEqual(["????","????"])
  it "shows explored fields", ->
    minefield.explore(0,0)
    expect(minefield.hints()).toEqual(["0???","????"])
  it "shows whole minefield when a mine is triggered", ->
    minefield.explore(1,2)
    expect(minefield.hints()).toEqual(["0122","01**"])

describe "Show minefield", ->
  minefield = new exports.Minefield(mines:["....","..**"], explored:true)
  it "shows rows for minefield", ->
    expect(minefield.html()).toMatch(/<tr>.*<\/tr><tr>.*<\/tr>/)
  it "shows cells for minefield row", ->
    expect(minefield.tr(0)).toMatch(/<td.*<\/td><td.*<\/td><td.*<\/td>/)
  it "shows cell location", ->
    expect(minefield.td(1,3)).toMatch(/data-row='1' data-col='3'/)
  it "shows minefield contents", ->
    expect(minefield.td(1,2)).toMatch(/>\*<\/td>/)
  it "shows minefield class", ->
    expect(minefield.td(1,2)).toMatch(/class='mine'/)
  it "shows correct class", ->
    expect(minefield.tdClass("0")).toEqual("mines-0")
    expect(minefield.tdClass("4")).toEqual("mines-4")
    expect(minefield.tdClass("?")).toEqual("unknown")