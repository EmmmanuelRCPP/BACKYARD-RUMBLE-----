extends Node2D

@onready var ground_layer = $TileMaps/LayerContainer/GroundLayer
@onready var effect_layer = $TileMaps/LayerContainer/EffectsLayer
@onready var unit_layer = $TileMaps/LayerContainer/UnitLayer
@onready var prop_layer = $TileMaps/LayerContainer/PropLayer

@onready var unitMenu = $%UnitMenu
@onready var unitStatus = $%UnitStatus

@export var gen_unit : PackedScene

@onready var pathfinding = $%Pathfinding
@onready var camera= $Camera

@export var difficulty = 0

enum state_type {OVERVIEW, UNIT_SELECT, ON_MENU, MOVEMENT_SELECT, ATTACK_SELECT, ENEMY_TURN, LOSE, WIN, PREPARATIONS}

var state = state_type.OVERVIEW

var entitySelected = null

var select_register = [0,0]

var player_units = []
var enemy_units = []

var traversable_map;
var nontraversable_map;

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if state == state_type.UNIT_SELECT:
			return
		var pos = get_global_mouse_position()
		pos = $TileMaps.get_mouse_tile(pos)
		var selected_unit = get_unit(pos)
		if state == state_type.OVERVIEW and selected_unit:
			unitStatus.select()
			$Camera.focus_on(selected_unit.global_position)
			if !unitStatus.active:
				await unitStatus.activate(selected_unit)
				unitStatus.select()
			if selected_unit.is_player():
				change_state(state_type.ON_MENU)
				register_select(pos, selected_unit)
				unitMenu.activate(selected_unit.can_move(), selected_unit.can_attack())
				%EndTurn.disabled = true
			else: 
				change_state(state_type.ON_MENU)
				%EndTurn.disabled = true
		elif state == state_type.MOVEMENT_SELECT and effect_layer.get_cell_tile_data(pos) and !selected_unit:
			var path = pathfinding.get_walk_path(select_register[0], pos)
			select_register[1].traverse_path(path)
			effect_layer.clear()
			await select_register[1].done_moving
			change_state(state_type.OVERVIEW)
			unitStatus.deactivate()
		elif state == state_type.ATTACK_SELECT and effect_layer.get_cell_tile_data(pos) and selected_unit:
			if !selected_unit.is_player():
				var damage = select_register[1].get_attack()
				select_register[1].perform_attack(selected_unit)
				effect_layer.clear()
				await select_register[1].done_attacking
				selected_unit.receive_damage(damage)
				await selected_unit.done_hurt
				change_state(state_type.OVERVIEW)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		if state == state_type.MOVEMENT_SELECT or state == state_type.ATTACK_SELECT:
			change_state(state_type.OVERVIEW)
			effect_layer.clear()
		if state == state_type.ON_MENU:
			unitMenu.deactivate()
			change_state(state_type.OVERVIEW)
			$Camera.focus_off()
	if event is InputEventMouseMotion:
		if state == state_type.OVERVIEW:
			var pos = get_global_mouse_position()
			pos = $TileMaps.get_mouse_tile(pos)
			var selected_unit = get_unit(pos)
			if selected_unit:
				if selected_unit != unitStatus.cur_unit:
					unitStatus.activate(selected_unit)
					selected_unit.play_animation("selected")
			elif unitStatus.active:
				unitStatus.deactivate()


func generate_walkRegion(pos : Vector2i, unit):
	var walkRegion = calcRange(pos, unit.get_movement())
	for tile in walkRegion:
		effect_layer.set_cell(tile, 2, Vector2i(2,2), 0)

func generate_attackRegion(pos : Vector2i, unit):
	var attackRegion = calcRange(pos, unit.get_atk_range())
	for tile in attackRegion:
		effect_layer.set_cell(tile, 2, Vector2i(1,2), 0)

func _ready() -> void:
	for cell in unit_layer.get_used_cells():
		var unit_instance = gen_unit.instantiate()
		var unitID = unit_layer.get_cell_tile_data(cell).get_custom_data("UnitID")
		unit_instance.set_to_tile(ground_layer.map_to_local(cell) , cell)
		unit_instance.levelManager = self
		unit_instance.data = UnitDB.DB.get_unit(unitID)
		$UnitContainer.add_child(unit_instance)
		if unit_instance.is_player():
			player_units.append(unit_instance)
		else:
			enemy_units.append(unit_instance)
		unit_instance.reset_actions()
	
	var traversable_map
	var nontraversable_map
	var region
	traversable_map = ground_layer.get_used_cells_by_id(2)
	
	nontraversable_map = ground_layer.get_used_cells_by_id(1)
	region = ground_layer.get_used_rect()
	
	pathfinding.set_map(traversable_map, nontraversable_map, region)
	unit_layer.hide()
	
	%TurnManager.begin_battle()

func calcRange(starting_pos : Vector2i, distance : int):
	const directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	var visited_tiles : Dictionary
	var queue : Array = []
	queue.append(starting_pos)
	visited_tiles[queue.front()] = 0
	if not (ground_layer.get_cell_tile_data(starting_pos) and ground_layer.get_cell_tile_data(starting_pos).get_custom_data("passable") == true):
		return {}
	while !queue.is_empty():
		for dir in directions:
			var node = queue.front() + dir
			var cost = visited_tiles[queue.front()] + 1
			if ground_layer.get_cell_tile_data(node):
				if cost <= distance and !visited_tiles.has(node) and ground_layer.get_cell_tile_data(node).get_custom_data("passable") == true:
					queue.append(node)
					visited_tiles[node] = cost
		queue.pop_front()
	
	
	return visited_tiles

func setEntitySelected(entity):
	if state == state_type.OVERVIEW:
		entitySelected = entity

func get_unit(position : Vector2i):
	for unit in $UnitContainer.get_children():
		if unit.current_pos == position and unit.is_alive:
			return unit
	return null

func register_select(pos, unit):
	if unit.get_alive():
		select_register[0] = pos
		select_register[1] = unit

func _on_boton_ataque_button_down() -> void:
	camera.focus_off()
	generate_attackRegion(select_register[0], select_register[1])
	change_state(state_type.ATTACK_SELECT)
	unitMenu.deactivate()

func _on_boton_movimiento_button_down() -> void:
	camera.focus_off()
	generate_walkRegion(select_register[0], select_register[1])
	unitMenu.deactivate()
	await get_tree().process_frame
	change_state(state_type.MOVEMENT_SELECT)

func get_player_units():
	return player_units.duplicate()

func get_enemy_target(enemy):
	return $Pathfinding.get_closest_player_path(enemy.get_tile_position())

func remove_unit(unit):
	if unit.is_player():
		player_units.erase(unit)
		if player_units.is_empty():
			level_lose()
	else:
		print("ENEMY REMOVED")
		enemy_units.erase(unit)
		if enemy_units.is_empty():
			level_win()

func level_lose():
	GameData.reset()
	change_state(state_type.LOSE)
	print("lose")
	MusicPlayer.play_sfx("lose")
	ScreenTransition.change_scene("res://title_screen.tscn", "lose")
	process_mode = ProcessMode.PROCESS_MODE_DISABLED

func level_win():
	GameData.add_money(randi_range(5, 10) * difficulty)
	PWR_Inventory.reset()
	change_state(state_type.WIN)
	MusicPlayer.play_sfx("win")
	ScreenTransition.change_scene("res://shop/shop.tscn", "win")
	process_mode = ProcessMode.PROCESS_MODE_DISABLED

func _on_end_turn_button_down() -> void:
	%EndTurn.disabled = true
	advance_phase()

func change_state(transition_state):
	print(state, "...", transition_state)
	state = transition_state
	match transition_state:
		state_type.OVERVIEW:
			%EndTurn.disabled = false
		state_type.ENEMY_TURN:
			%EndTurn.disabled = true
		state_type.ON_MENU:
			%EndTurn.disabled = true
		state_type.LOSE:
			$UI.hide()
		state_type.WIN:
			$UI.hide()

func advance_phase():
	%TurnManager.advance_phase()

func begin_enemy_turn():
	change_state(state_type.ENEMY_TURN)
	$%EndTurn.hide()
	print("in enemy turn")
	for player in player_units:
		player.reset_actions()
	print("BEGINNING ENEMIES")
	for enemy in enemy_units:
		$Camera.focus_on(enemy.global_position, false)
		enemy.start_turn()
		await enemy.enemy_done
	print("d")
	camera.focus_off()
	%EndTurn.show()
	%TurnManager.advance_phase()

func begin_player_turn():
	if player_units.is_empty():
		return
	print("in player turn")
	
	for enemy in enemy_units:
		enemy.reset_actions()
	for player in player_units:
		player.start_turn()
	change_state(state_type.OVERVIEW)
	camera.focus_on(player_units[0].global_position, false)


func checkPlayers():
	print("CHECK")
	for i in player_units:
		if i.can_move() or i.can_attack():
			return
	#All player actions have been done
	advance_phase()

func begin_preparations():
	change_state(state_type.PREPARATIONS)

func begin_battle():
	print("BEGINNING BATTLE")
	for player in player_units:
		player.updateInventory()
		player.begin_battle()
	for enemy in enemy_units:
		enemy.begin_battle()
	begin_player_turn()
