describe 'Explored minefield', ->
  expectHints = (mines)->
    minefield = new exports.Minefield(mines)
    minefield.explored_ = ((true for column in mineRow) for mineRow in mines)
    expect(minefield.hints())
  it "should indicate empty minefield", ->
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
    expectHints([".."]).toEqual(["00"])
  it "should indicate mines", ->
    expectHints(["**", "**"]).toEqual(["**","**"])
  it "should find neighbouring mines", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
  it "should count neighbouring mines", ->
    expectHints(["*.*"]).toEqual(["*2*"])

describe "Unexplored minefield",->
  it "should only show explored fields", ->
    minefield = new exports.Minefield(["*.*","..."])
    minefield.explore("0,1")
    minefield.explore("1,0")
    expect(minefield.hints()).toEqual(["?2?","1??"])
  it "should show minefield when player steps on mine", ->
    minefield = new exports.Minefield(["*.*", "..."])
    minefield.explore("0,0")
    expect(minefield.hints()).toEqual(["!2*", "121"])
  it "should show minefield when player explores all safe squares", ->
    minefield = new exports.Minefield(["*.*", "..."])
    minefield.explore(cell) for cell in ["0,1","1,0","1,1","1,2"]
    expect(minefield.hints()).toEqual(["*2*", "121"])

describe "Display minefield", ->
  it "should create html table for minefield", ->
    minefield = new exports.Minefield(["...","..."])
    expect(minefield.html()).toMatch(/<tr[^<]*<td.*<td.*<td.*<\/tr><tr[^<]*<td.*<td.*<td.*<\/tr>/)
  it "should show cells on minefield", ->
    minefield = new exports.Minefield([])
    expect(minefield.htmlCell_(0,2,"1")).toEqual("<td class='mines-1' data-cell='0,2'>1</td>")
  it "should show html class for cells", ->
    minefield = new exports.Minefield([])
    expect(minefield.cellClass_("!")).toEqual("mine triggered")
    expect(minefield.cellClass_("*")).toEqual("mine")
    expect(minefield.cellClass_("?")).toEqual("unknown")
    expect(minefield.cellClass_(2)).toEqual("mines-2")
