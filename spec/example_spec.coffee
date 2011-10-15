describe 'Example project', ->

  it "tell hello world", ->
    example = new exports.Example()
    expect(example.sayHello("Jeremy")).toEqual("Hello Jeremy")

