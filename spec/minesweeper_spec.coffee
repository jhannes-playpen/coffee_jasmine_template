describe 'Minesweeper', ->                                                                                        

  expectHints = (mines) ->
    minefield = new exports.Minefield(mines:mines, explored:true)
    expect(minefield.hints())

  expectHtml = (mines) ->
    minefield = new exports.Minefield(mines:mines, explored:true)
    expect(minefield.html())
    

  it 'shows empty minefield', ->                 
    expectHints(["...","...","..."]).toEqual ["000","000","000"]

  it 'shows shape of minefield', ->                 
    expectHints(["....","...."]).toEqual ["0000","0000"]
    
  it 'indicates mines', ->
    expectHints(["**","**"]).toEqual ["**","**"]
    
  it 'detects mines to the right', ->
    expectHints([".*"]).toEqual ["1*"]
  
  it 'detects mines to the left', ->
    expectHints(["*."]).toEqual ["*1"]
    
  it 'detects mines above', ->
    expectHints(["*","."]).toEqual ["*","1"]
  
  it 'detects mines below', ->
    expectHints([".","*"]).toEqual ["1","*"]
  
  it 'detects mine in the middle', ->
    expectHints(["...",".*.","..."]).toEqual ["111","1*1","111"]
    
  it "count neighbouring mines", ->
    expectHints(["***","*.*","***"]).toEqual ["***","*8*","***"]
    
   it "render html", ->
    expectHtml(["."]).toEqual '<tr><td data-row="0" data-col="0" class="mines-0">0</td></tr>'
    
  it "renders html shape columns", ->
    expectHtml(["..."]).toMatch /<tr.*<td.*<td.*<td.*<\/tr>/

  it "renders html shape rows", ->
    expectHtml(["...","..."]).toMatch /<tr.*<tr.*/
    
  it "renders html td coordinates", ->
    expectHtml(["...","..."]).toMatch /data-row="1" data-col="2"/

  it "renders html td mines count", ->
    expectHtml([".*"]).toMatch /class="mines-1">1</
    
  it "renders html td mine", ->
    expectHtml(["*"]).toMatch /class="mine( .*)?">\*</
    
  it "hides unexplored cells", ->
    minefield = new exports.Minefield(mines:["..",".."], explored:false)
    expect(minefield.hints()).toEqual ["??","??"]

  it "shows explored cells", ->
    minefield = new exports.Minefield(mines:["..",".."], explored:false)
    minefield.explore 1,1
    expect(minefield.hints()).toEqual ["??","?0"]
    
  it "reveals minefield when mine is triggered", ->
    minefield = new exports.Minefield(mines:["*.",".."], explored:false)
    minefield.explore 0,0
    expect(minefield.hints()).toEqual ["*1","11"]
  
  it "shows triggered mine", ->
    minefield = new exports.Minefield(mines:["*"], explored:false)
    minefield.explore 0,0
    expect(minefield.html()).toMatch /class="mine( .*)?triggered( .*)?">\*</
    
  it "reveals field when all empty cells are explored", ->
    minefield = new exports.Minefield(mines:["*.",".."], explored:false)
    minefield.explore(row,col) for [row,col] in [[0,1],[1,0],[1,1]]
    expect(minefield.hints()).toEqual ["*1","11"]
  
  