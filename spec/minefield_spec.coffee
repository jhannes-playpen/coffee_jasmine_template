describe "Explored minefield", ->
  expectHints = (mines) ->
    expect(new exports.Minefield(mines:mines,explored:true).hints())

  it "shows empty cells",->
    expectHints(["...","...","..."]).toEqual(["000", "000", "000"])

  it "shows minefield shape",->
    expectHints(["....","...."]).toEqual(["0000", "0000"])

  it "shows mine",->
    expectHints(["*"]).toEqual(["*"])

  it "indicates mine to the left",->
    expectHints(["*."]).toEqual(["*1"])

  it "indicates mine to the right",->
    expectHints([".*"]).toEqual(["1*"])

  it "indicates mine above",->
    expectHints(["*","."]).toEqual(["*","1"])

  it "indicates mine below",->
    expectHints([".","*"]).toEqual(["1","*"])

  it "shows hints around mine",->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])

  it "count mines around cell",->
    expectHints(["***","*.*","***"]).toEqual(["***","*8*","***"])
    
describe "Unexplored minefield", ->

  it "hides unexplored cells", ->
    minefield = new exports.Minefield(mines:["..*","..."],explored:false)
    expect(minefield.hints()).toEqual(["???","???"])

  it "shows explored cells", ->
    minefield = new exports.Minefield(mines:["..*","..."],explored:false)
    minefield.explore(0,0)
    expect(minefield.hints()).toEqual(["0??","???"])
