extends Node2D

@onready var layer_container : Node = $LayerContainer
@onready var ground_layer : TileMapLayer = $%GroundLayer
@onready var effect_layer : TileMapLayer = $%EffectsLayer
@onready var unit_layer : TileMapLayer = $%UnitLayer
@onready var prop_layer : TileMapLayer = $%PropLayer

func get_tile_information() -> Array:
	var arr := []
	for cell in ground_layer.get_used_cells():
		var tile : TileData = ground_layer.get_cell_tile_data(cell)
		tile.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if tile.get_custom_data("passable") == true:
			arr.append(cell)
	return arr

func _ready() -> void:
	var a = get_tile_information()
	pass

func get_mouse_tile(mouse_pos: Vector2):
	var local_pos = ground_layer.to_local(mouse_pos)
	var tile = ground_layer.local_to_map(local_pos)
	return tile
