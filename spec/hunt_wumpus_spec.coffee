
describe 'Wumpus Hunt', ->

  beforeEach ->
    @addMatchers({
      toBeOneOf: (array)-> array.indexOf(this.actual) >= 0,
      toContainWhere: (f)->
        for element in this.actual
          return true if f(element)
        return false
      toHaveSameElementsAs: (expected)->
        missing = expected.slice().removeAll(this.actual)
        extra = this.actual.slice().removeAll(expected)
        this.message = (matcher,args)->
          "missing: #{missing}, extra: #{extra} (actual: #{this.actual}, expected: #{expected})"
        missing.isEmpty() and extra.isEmpty()
    })

  it "should generate rooms in cave", ->
    cave = new exports.Cave()
    cave.createCave(10)
    expect(cave.rooms[3].roomNumber).toEqual(3)
    
  it "should have corridors from all rooms", ->
    cave = new exports.Cave()
    cave.createCave(10)
    expect(room.corridors.length).toBeGreaterThan(0) for room in cave.rooms
    expect(room.corridors[0]).toBeOneOf(cave.roomNumbers()) for room in cave.rooms  
    
  it "should not have rooms with corridors to the same room", ->
    cave = new exports.Cave()
    cave.createCave(10)
    expect(room.corridors[0]).not.toBe(room) for room in cave.rooms
    
  it "should have a room with the Wumpus", ->
    cave = new exports.Cave()
    cave.createCave(10)
    expect((room for room in cave.rooms when room.hasWumpus).length).toEqual(1)
    
  it "should find adjacent rooms", ->
    cave = new exports.Cave()
    cave.createRooms(4)
    cave.createCorridor(corridor[0], corridor[1]) for corridor in [[0,1],[0,2],[1,2],[2,3]]
    expect(cave.rooms[0].corridors).toEqual([1,2])
    expect(cave.rooms[2].corridors).toEqual([0,1,3])
    expect(cave.rooms[3].corridors).toEqual([2])
    
  it "should not have any islands", ->
    cave = new exports.Cave(50)
    expect(cave.connectedRooms(0)).toHaveSameElementsAs(cave.roomNumbers())
    expect(cave.connectedRooms(10)).toHaveSameElementsAs(cave.roomNumbers())

  it "should smell of wumpus close to wumpus", ->
    cave = new exports.Cave()
    cave.createRooms(4, 0)
    expect(cave.rooms[0].hasWumpus).toBeTruthy()
    cave.createCorridor(corridor[0], corridor[1]) for corridor in [[0,1],[0,2],[1,2],[2,3]]
    expect(cave.smellsOfWumpus(1)).toBeTruthy()
    expect(cave.smellsOfWumpus(2)).toBeTruthy()
    expect(cave.smellsOfWumpus(3)).toBeFalsy()
  
  it "should have rooms with bats", ->
    cave = new exports.Cave(50)
    expect((room for room in cave.rooms when room.hasBats).length).toBeGreaterThan(1)

  it "should track which rooms are visited", ->
    cave = new exports.Cave(10)
    visited = cave.visitedRooms
    expect(visited[0]).toBeOneOf(cave.roomNumbers())
    nextRoom = cave.adjacentRooms(visited[0])[0]
    cave.visit(nextRoom)
    expect(cave.visitedRooms).toContain(nextRoom)

  it "should hear bats", ->
    cave = new exports.Cave()
    cave.createRooms(4, 0, 0)
    cave.createCorridor(0,1)
    cave.createCorridor(1,2)
    cave.createCorridor(2,3)
    cave.rooms[1].hasBats = true
    cave.rooms[2].hasBats = false
    expect(cave.hearBats(3)).toBeFalsy()
    expect(cave.hearBats(2)).toBeTruthy()
  
  it "should have some corridors with monsters", ->
    cave = new exports.Cave(50)
    expect((corridor for corridor in cave.corridors() when corridor.hasMonsters).length).toBeGreaterThan(1)
    expect((corridor for corridor in cave.corridors() when not corridor.hasMonsters).length).toBeGreaterThan(1)
    
  
  it "should be noisy near corridors with monsters"
  
