extends Node

var map = AStarGrid2D.new()

func get_closest_player_path(pos):
	var player_unit = get_parent().get_player_units()
	var shortest_path = map.get_id_path(pos, player_unit[0].current_pos)
	player_unit.pop_front()
	for unit in player_unit:
		var unit_path = map.get_id_path(pos, unit.current_pos)
		if unit_path.size() < shortest_path.size():
			shortest_path = unit_path
	return shortest_path

func get_walk_path(begin_position, end_position) -> Array:
	return map.get_id_path(begin_position, end_position)

func set_map(walkable, obstacle, region):
	map.default_compute_heuristic = map.HEURISTIC_MANHATTAN
	map.diagonal_mode = map.DIAGONAL_MODE_NEVER
	map.region = region
	map.cell_size = Vector2(128, 128)
	map.update()
	map.fill_solid_region(region)
	for tile in walkable:
		map.set_point_solid(tile, false)
