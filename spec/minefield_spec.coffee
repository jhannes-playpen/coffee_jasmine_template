describe 'Minefield', ->
  expectHints = (mines)->
    expect(new exports.Minefield(mines).hints())

  it "should indicate empty minefield", ->
    expectHints(["...","...","..."]).toEqual(["000","000","000"])
    expectHints([".."]).toEqual(["00"])
    
  it "should indicate mines", ->
    expectHints(["**", "**"]).toEqual(["**","**"])
    
  it "should find neighbouring mines", ->
    expectHints(["...",".*.","..."]).toEqual(["111","1*1","111"])
    
  it "should count neighbouring mines", ->
    expectHints(["*.*"]).toEqual(["*2*"])
    
  it "should show unexplored minefield", ->
    minefield = new exports.Minefield([".","."])
    expect(minefield.html()).toEqual("<tr><td class='unknown' data-cell='0,0'>?</td></tr><tr><td class='unknown' data-cell='1,0'>?</td></tr>")
  it "should show explored fields", ->
    minefield = new exports.Minefield(["*.*","..."])
    minefield.explore("0,1")
    minefield.explore("1,0")
    expect(minefield.htmlCell_(0,1)).toEqual("<td class='mines-2' data-cell='0,1'>2</td>")
    expect(minefield.htmlCell_(1,0)).toEqual("<td class='mines-1' data-cell='1,0'>1</td>")
  it "should show minefield when player steps on mine", ->
    minefield = new exports.Minefield(["**."])
    minefield.explore("0,0")
    expect(minefield.htmlCell_(0,0)).toEqual("<td class='mine triggered' data-cell='0,0'>*</td>")
    expect(minefield.htmlCell_(0,1)).toEqual("<td class='mine' data-cell='0,1'>*</td>")
    expect(minefield.htmlCell_(0,2)).toEqual("<td class='mines-1' data-cell='0,2'>1</td>")
  it "should show minefield when player explores all safe squares", ->
    minefield = new exports.Minefield(["**."])
    minefield.explore("0,2")
    expect(minefield.htmlCell_(0,0)).toEqual("<td class='mine explored' data-cell='0,0'>*</td>")
    expect(minefield.htmlCell_(0,2)).toEqual("<td class='mines-1' data-cell='0,2'>1</td>")

