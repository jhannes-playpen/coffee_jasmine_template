class exports.Cave
  constructor: (args)->
    @visitedRooms = []
    @corridors = []
    @createCave(args) if args?

  nodes: ->
    (@node(room) for room in @rooms)
    
  node: (room)->
    { "id": "room-#{room.roomNumber}", "title": @roomClass(room.roomNumber), "className": @roomClass(room.roomNumber) }
  
  roomClass: (room)->
    className = "room room-#{room}"
    if @isVisited(room)
      className += " wumpus" if @rooms[room].hasWumpus
      className += " bats" if @rooms[room].hasBats
      className += " near-bats" if @hearBats(room)
      className += " near-wumpus" if @smellsOfWumpus(room)
      className += " near-monsters" if @hearMonsters(room)
    else
      className += " unknown" unless (1 for visitedRoom in @visitedRooms when @rooms[visitedRoom].corridors.contains(room)).isPresent()
      className += " unvisited"
    className += " player" if @playerPosition == room
    className += " adjacent" if @isAdjacentToPlayer(room)
    className
  
  isAdjacentToPlayer: (room)->@playerPosition? and @rooms[@playerPosition].corridors.contains(room)
  
  isVisited: (room)->@visitedRooms.contains(room)
    
  links: ->
    (@link(corridor) for corridor in @corridors)
    
  link: (corridor)->
    { source: corridor.from, target: corridor.to, id: "line-#{corridor.from}-#{corridor.to}", className: @linkClass(corridor.to, corridor.from) }

  linkClass: (fromRoom,toRoom)->
    className = "corridor"
    className += " monsters" if @corridor(fromRoom,toRoom) and @corridor(fromRoom,toRoom).hasMonsters
    className += " unknown" unless @isVisited(fromRoom) or @isVisited(toRoom)
    className
    
  corridor: (from,to)->
    result = (corridor for corridor in @corridors when (corridor.from == from and corridor.to == to) or (corridor.to == from and corridor.from == to))
    (if result? then result[0] else null)
    
  setPlayerPosition: (@playerPosition)->
    @visitedRooms.push(@playerPosition)
    
  walkTo: (newPosition,callback,charging)->
    corridor = @corridor(@playerPosition,newPosition)
    if not corridor?
      callback("You can't go that way") if callback?
    else if corridor.hasMonsters
      callback("You were eaten by a monster") if callback?
      @playerPosition = null
      @visitedRooms = [0...@rooms.length]
    else if @rooms[newPosition].hasWumpus
      if charging
        callback("You win: You kill the wumpus") if callback?
      else
        callback("The wumpus eats you") if callback?
      @playerPosition = null
      @visitedRooms = [0...@rooms.length]
    else if charging
      callback("Game over. You charge into the darkness and knocks yourself unconcious") if callback?
      @playerPosition = null
      @visitedRooms = [0...@rooms.length]      
    else if @rooms[newPosition].hasBats
      callback("The bats carry you off") if callback?
      @visitedRooms.push(newPosition)
      replacedPosition = Math.floor((@rooms.length-1)*Math.random())
      replacedPosition+=1 if replacedPosition >= newPosition
      @setPlayerPosition(replacedPosition)
    else
      @setPlayerPosition(newPosition)
  
  visit: (roomNumber)->
    @visitedRooms.push(roomNumber)

  createCave: (roomCount, monsterChance, batChance)->
    @visitedRooms = []
    @corridors = []
    monsterChance ?= 0.2
    @createRooms(roomCount, null, batChance)
    @corridorCount_ = 0
    while @corridorCount_ < @rooms.length*3
      @createCorridor(null, null, { hasMonsters: Math.random() < monsterChance })
    islands = @findIslands()
    for island in [1...islands.length]
      @createCorridor(islands[island-1][0], islands[island][0], { hasMonsters: Math.random() < monsterChance })
    @findIslands()
    @setPlayerPosition(0)
      
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
  
  createCorridor: (fromRoom,toRoom,properties)->
    fromRoom ?= @randomRoom()
    toRoom ?= @randomRoom()
    hasMonsters = (if properties? then properties.hasMonsters else false)
    unless fromRoom == toRoom
      @corridors.push(new Corridor(fromRoom,toRoom, hasMonsters))
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
  hearMonsters: (room)->
    (corridor for corridor in @corridors when corridor.connects(room) and corridor.hasMonsters).isPresent()

class Corridor
  constructor: (@from,@to,@hasMonsters)->
  connects: (room) -> @from == room or @to == room  
  
  
class Room
  constructor: (@roomNumber,batChance)->
    @corridors = []
    @hasBats = Math.random() < (batChance || 0.2)

  addCorridor: (destinationRoom)->
    @corridors.push(destinationRoom) unless @corridors.indexOf(destinationRoom) >= 0

