extends Node


var astar_grid = AStarGrid2D.new()

func _ready() -> void:
	astar_grid.region = Rect2i(0, 0, 32, 32)
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.update()
	var d = calcWalk(Vector2i(5,5), 3)

func calcWalk(starting_pos : Vector2i, distance : int):
	const directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	var visited_tiles : Dictionary
	var queue : Array = []
	queue.append(starting_pos)
	visited_tiles[queue.front()] = 0
	while !queue.is_empty():
		for dir in directions:
			var node = queue.front() + dir
			var cost = visited_tiles[queue.front()] + 1
			if cost <= distance and !visited_tiles.has(node):
				queue.append(node)
				visited_tiles[node] = cost
		queue.pop_front()
	
	
	return visited_tiles
