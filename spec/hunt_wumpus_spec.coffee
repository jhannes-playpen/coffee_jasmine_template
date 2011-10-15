describe 'Generated Cave', ->

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
    expect(cave.nodes()[3].id).toEqual("room-3")
    
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
    expect(cave.links().length).toEqual(4)
    expect(cave.links()[0].source).toEqual(0)
    expect(cave.links()[0].target).toEqual(1)
    
  it "should not have any islands", ->
    cave = new exports.Cave(50)
    expect(cave.connectedRooms(0)).toHaveSameElementsAs(cave.roomNumbers())
    expect(cave.connectedRooms(10)).toHaveSameElementsAs(cave.roomNumbers())

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
  
  it "should have some corridors with monsters", ->
    cave = new exports.Cave(50)
    expect((corridor for corridor in cave.corridors when corridor.hasMonsters).length).toBeGreaterThan(1)
    expect((corridor for corridor in cave.corridors when not corridor.hasMonsters).length).toBeGreaterThan(1)
  
    
describe "Visited cave", ->
  cave = null
  
  beforeEach ->
    cave = new exports.Cave()
    cave.createRooms(4,0,0)
    cave.rooms[1].hasBats = true
    cave.rooms[2].hasBats = false
    cave.createCorridor(0,1, {hasMonsters: false})
    cave.createCorridor(1,2, {hasMonsters: true})
    cave.createCorridor(2,3)
    cave.createCorridor(0,2)
    cave.visitedRooms = [0...4]

  it "should have wumpus", ->
    expect(cave.roomClass(0)).toContain(" wumpus")
  it "should smell of wumpus close to wumpus", ->
    expect(cave.roomClass(1)).toContain("near-wumpus")
    expect(cave.roomClass(2)).toContain("near-wumpus")
    expect(cave.roomClass(3)).not.toContain("near-wumpus")
  it "should hear bats", ->
    expect(cave.roomClass(1)).toContain(" bats")
    expect(cave.roomClass(2)).toContain("near-bats")
    expect(cave.roomClass(3)).not.toContain("near-bats")
  it "should have corridors with monsters", ->
    expect(cave.linkClass(0,1)).not.toContain("monsters")
    expect(cave.linkClass(1,2)).toContain("monsters")
  it "should be noisy near corridors with monsters", ->
    expect(cave.roomClass(0)).not.toContain("near-monsters")
    expect(cave.roomClass(1)).toContain("near-monsters")
    expect(cave.roomClass(2)).toContain("near-monsters")

describe "Unisited cave", ->
  cave = null
  
  beforeEach ->
    @addMatchers({
      toBeOneOf: (array)-> array.indexOf(this.actual) >= 0
    })
    cave = new exports.Cave()
    cave.createRooms(6,0,0)
    cave.rooms[1].hasBats = true
    cave.rooms[5].hasBats = true
    cave.createCorridor(0,1, {hasMonsters: false})
    cave.createCorridor(1,2, {hasMonsters: true})
    cave.createCorridor(2,3)
    cave.createCorridor(0,2)
    cave.createCorridor(3,4)
    cave.createCorridor(4,5)
    cave.visitedRooms = []
    cave.setPlayerPosition(3)

  it "should indicate player position", ->
    expect(cave.roomClass(3)).toContain("player")
    expect(cave.roomClass(0)).not.toContain("player")
  it "should indicate unvisited nodes", ->
    expect(cave.roomClass(room)).toContain("unvisited") for room in [0,1,2]
    expect(cave.roomClass(3)).not.toContain("unvisited")
  it "should visit new nodes", ->
    cave.setPlayerPosition(2)
    expect(cave.roomClass(room)).toContain("unvisited") for room in [0,1,4,5]
    expect(cave.roomClass(room)).not.toContain("unvisited") for room in [2,3]
  it "should indicate adjacent rooms", ->
    expect(cave.roomClass(room)).toContain("adjacent") for room in [2]
    expect(cave.roomClass(room)).not.toContain("adjacent") for room in [0,1,3]
    cave.setPlayerPosition(2)
    expect(cave.roomClass(room)).toContain("adjacent") for room in [0,1,3]
    expect(cave.roomClass(room)).not.toContain("adjacent") for room in [2]
  it "should only contents in visited rooms", ->
    expect(cave.roomClass(0)).not.toContain("wumpus")
    expect(cave.roomClass(1)).not.toContain("bats")
    expect(cave.roomClass(2)).not.toContain("near-bats")
  it "should indicate non-adjacent unvisited rooms as unknown", ->
    expect(cave.roomClass(room)).toContain("unknown") for room in [0,1,5]
    expect(cave.roomClass(room)).not.toContain("unknown") for room in [2,3,4]
    cave.setPlayerPosition(4)
    expect(cave.roomClass(room)).not.toContain("unknown") for room in [2,3,4,5]
  it "should indicate unknown corridors", ->
    expect(cave.linkClass(0,1)).toContain("unknown")
    expect(cave.linkClass(2,3)).not.toContain("unknown")
  it "should not let you walk to an unconnected room", ->
    results = []
    cave.walkTo(0, (message)->results.push(message))
    expect(results[0]).toEqual("You can't go that way")
    expect(cave.playerPosition).toEqual(3)
  it "should kill player when he encounters a monster", ->
    cave.walkTo(2)
    results = []
    cave.walkTo(1, (result)->results.push(result))
    expect(results[0]).toEqual("You were eaten by a monster")
    expect(cave.visitedRooms).toEqual([0...6])
  it "should move player when he encounters bats", ->
    cave.walkTo(4)
    results = []
    cave.walkTo(5, (result)->results.push(result))
    expect(results[0]).toEqual("The bats carry you off")
    expect(cave.playerPosition).not.toEqual(5)
  it "kills players who stumble into the wumpus", ->
    cave.walkTo(2)
    results = []
    cave.walkTo(0, (result)->results.push(result))
    expect(results[0]).toEqual("The wumpus eats you")
    expect(cave.visitedRooms).toEqual([0...6])
  it "declares player as winner if he charges the wumpus", ->
    cave.walkTo(2)
    results = []
    cave.walkTo(0, ((result)->results.push(result)), true)
    expect(results[0]).toEqual("You win: You kill the wumpus")
    expect(cave.visitedRooms).toEqual([0...6])
  it "kills the player who charge into another room", ->
    results = []
    cave.walkTo(2, ((result)->results.push(result)), true)
    expect(results[0]).toEqual("Game over. You charge into the darkness and knocks yourself unconcious")
    expect(cave.visitedRooms).toEqual([0...6])
    
    

