describe "Minefield", ->

  expectHints = (mines) ->
    minefield = new exports.Minefield(mines:mines)
    expect(minefield.hints())

  it "shows empty minefield", ->
    expectHints(["...","...","..."]).toEqual ["000","000","000"]

  it "shows minefield shape", ->
    expectHints(["..","..","..",".."]).toEqual ["00","00","00","00"]
    
  it "shows mines", ->
    expectHints(["**"]).toEqual ["**"]

  it "shows hints around mine", ->
    expectHints(["...",".*.","..."]).toEqual ["111","1*1","111"]

  it "count mines around the cell", ->
    expectHints(["***","*.*","***"]).toEqual ["***","*8*","***"]
    
  it "acceptance test", ->
    expectHints(["....",".*..",".*.*","...*"]).toEqual ["1110","2*31","2*4*","113*"]
    