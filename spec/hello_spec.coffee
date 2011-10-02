describe 'jasmine-node', ->

  it 'should pass', ->
    expect(1+2).toEqual(3)

  it 'should be happy', ->
    expect("happy").toEqual("happy")
    
  it 'should calculate sum', ->
    expect(exports.calculateSum(1, 2, 3, 4)).toEqual 10