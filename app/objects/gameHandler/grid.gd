extends TileMap

# PLAYER = 1 OBSTICLE = 2 COLLECTABLE = 3 NPC = 4

var half_cell_size = cell_size / 2
var grid = []
var gridSize = Vector2(20, 11)


onready var playerScene = load("res://app/objects/entities/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(gridSize.x):
		grid.append([])
		for y in range(gridSize.y):
			grid[x].append(null)
	for child in get_children():
		var childPos = world_to_map(child.position)
		grid[childPos.x][childPos.y] = child.type
	
func isCellVacent(pos, direction):
	#print("hi")
	var gridPos = world_to_map(pos) + direction
	if gridPos.x < gridSize.x && gridPos.x >= 0:
		if gridPos.y < gridSize.y && gridPos.y >= 0:
			if grid[gridPos.x][gridPos.y] == null:
				return true
	return false

func updateChildPos(child):
	var gridPos = world_to_map(child.position)
	grid[gridPos.x][gridPos.y] = null
	
	var newGridPos = gridPos + child.moveDir
	grid[newGridPos.x][newGridPos.y] = child.type
	
	var targetPos = map_to_world(newGridPos)
	return targetPos
	
	return(Vector2(0,0))


func findNpcInRange(child):
	var childPos = world_to_map(child.position)
	
	for x in range(childPos.x, gridSize.x):
		if grid[x][childPos.y] == 4:
			return(Vector2(1, 0))
	
	for x in range(childPos.x, 0, -1):
		if grid[x][childPos.y] == 4:
			return(Vector2(-1, 0))	
	
	for y in range(childPos.y, gridSize.y):
		if grid[childPos.x][y] == 4:
			return(Vector2(0, 1))	
	
	for y in range(childPos.y, 0, -1):	
		if grid[childPos.x][y] == 4:
			return(Vector2(-1, 0))

	return(null)
