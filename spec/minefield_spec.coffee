describe "Explored minefield", ->

  expectHints = (mines) ->
    expect(new exports.Minefield(mines:mines,explored:true).hints())

  it "shows rows and columns", ->
    expectHints(["...","..."]).toEqual ["000", "000"]
    
  it "shows minefield shape", ->
    expectHints(["..","..",".."]).toEqual ["00","00","00"]
  
  it "shows mines", ->
    expectHints(["**"]).toEqual ["**"]
    
  it "shows hints around mine", ->
    expectHints(["...", ".*.", "..."]).toEqual ["111","1*1", "111"]  

  it "counts mines around cell", ->
    expectHints(["***", "*.*", "***"]).toEqual ["***","*8*", "***"]


describe "Unexplored minefiled", ->

  it "hides minefield at start", ->
    minefield = new exports.Minefield(mines:["**"], explored:false)
    expect(minefield.hints()).toEqual ["??"]

  it "reveals explored cells", ->
    minefield = new exports.Minefield(mines:[".."], explored:false)
    minefield.explore(0,1)
    expect(minefield.hints()).toEqual ["?0"]