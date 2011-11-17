describe "Explored minefield", ->

  it "shows empty cells",->
    mines    = ["...",
                "...",
                "..."]
    expected = ["000",
                "000",
                "000"]
    expect
