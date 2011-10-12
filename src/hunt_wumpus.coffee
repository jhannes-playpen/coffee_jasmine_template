
class exports.Cave
  constructor: (args)->
    @visitedRooms = []
    @createCave(args) if args?

  nodes: ->
    (room.node() for room in @rooms)
    
  links: ->
    result = []
    for room in @rooms
      result = result.concat room.links()
    result
    
  corridors: ()->
    [{hasMonsters: true}, {hasMonsters:true}, {hasMonsters: false}, {hasMonsters:false}]
  
  visit: (roomNumber)->
    @visitedRooms.push(roomNumber)
    
  createCave: (roomCount)->
    @createRooms(roomCount)
    @corridorCount_ = 0
    while @corridorCount_ < @rooms.length*3
      @createCorridor()
    islands = @findIslands()
    for island in [1...islands.length]
      @createCorridor(islands[island-1][0], islands[island][0])
    @findIslands()
    @visitedRooms.push 0
      
  findIslands: ->
    unvisitedRooms = @roomNumbers()
    islands = []
    until unvisitedRooms.isEmpty()
      room = unvisitedRooms.pop()
      island = @connectedRooms(room)
      unvisitedRooms.remove room for room in island
      islands.push island
    islands
  
  connectedRooms: (room)->
    result = []
    adjacentRooms = [room]
    until adjacentRooms.isEmpty()
      adjacentRoom = adjacentRooms.pop()
      continue if result.contains(adjacentRoom)
      result.push adjacentRoom
      adjacentRooms = adjacentRooms.concat(@rooms[adjacentRoom].corridors)
    result.sort (a,b)->a-b
    return result
  
  createCorridor: (fromRoom,toRoom)->
    fromRoom ?= @randomRoom()
    toRoom ?= @randomRoom()
    unless fromRoom == toRoom
      @rooms[fromRoom].addCorridor toRoom
      @rooms[toRoom].addCorridor fromRoom
      @corridorCount_++

  createRooms: (roomCount, wumpusRoom, batChance)->
    @rooms = ((new Room(room,batChance) for room in [0...roomCount]))
    wumpusRoom = @randomRoom() unless wumpusRoom?
    @rooms[wumpusRoom].hasWumpus = true

  adjacentRooms: (room)->
    (@rooms[neighbour] for neighbour in @rooms[room].corridors)
  
  roomNumbers: -> (room.roomNumber for room in @rooms)

  randomRoom: -> Math.floor(@rooms.length*Math.random())

  smellsOfWumpus: (room)->
    (neighbour for neighbour in @adjacentRooms(room) when neighbour.hasWumpus).isPresent()
  hearBats: (room)->
    (neighbour for neighbour in @adjacentRooms(room) when neighbour.hasBats).isPresent()
  
class Room
  constructor: (@roomNumber,batChance)->
    @corridors = []
    @hasBats = Math.random() < (batChance || 0.2)

  addCorridor: (destinationRoom)->
    @corridors.push(destinationRoom) unless @corridors.indexOf(destinationRoom) >= 0

  node: ->
    #{ "id": "room-#{@roomNumber}", "hasWumpus": @hasWumpus, "hasBats": false }
    { "id": "room-#{@roomNumber}", "name": "#{@roomNumber}", "className": (if @hasWumpus then "wumpus" else if @hasBats then "bats" else "empty") }
    
  links: ->
    ({"source":@roomNumber,"target":destinationRoom,"value":8,"id":"line-#{@roomNumber}-#{destinationRoom}"} for destinationRoom in @corridors)

