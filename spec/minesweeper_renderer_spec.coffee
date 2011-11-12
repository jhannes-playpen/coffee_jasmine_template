describe "Display minefield", ->
  squareField = new exports.MinefieldRenderer(new exports.Minefield(mines:["...","...","..."],explored:true))
  rectField = new exports.MinefieldRenderer(new exports.Minefield(mines:["....","...."],explored:true))

  it "shows minefield", ->
    expect(squareField.html().match(/<tr>/g).length).toEqual(3)
    expect(rectField.html().match(/<tr>/g).length).toEqual(2)
  it "shows rows", ->
    expect(squareField.tr(0).match(/<td/g).length).toEqual(3)
    expect(rectField.tr(0).match(/<td/g).length).toEqual(4)
  it "shows cell position", ->
    expect(squareField.td(1,2)).toMatch(/data-row='1' data-col='2'/)
  it "shows cell content", ->
    expect(squareField.td(1,2)).toMatch(/>0<\/td/)
  it "shows cell class", ->
    expect(squareField.td(1,2)).toMatch(/class='mines-0'/)
  it "find cell class", ->
    expect(squareField.tdClass('?')).toEqual("unexplored")
    expect(squareField.tdClass('*')).toEqual("mine")
    expect(squareField.tdClass(3)).toEqual("mines-3")
    expect(squareField.tdClass(6)).toEqual("mines-6")

