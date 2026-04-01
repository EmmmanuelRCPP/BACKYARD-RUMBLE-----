extends Area2D

class_name unit

var current_pos := Vector2i(0,0)
var hovered := false
var levelManager = null
var data : UnitData

var max_hp: int = 20
var attack: int = 5
var avoid: int = 5
var luck: int = 0
var movement: int = 5
var attack_range: int = 1
var current_hp: int = 20
var inventory := []
var is_alive = true


signal enemy_done
signal done_moving
signal done_attacking
signal done_hurt


@onready var sprite = $UnitSprite/AnimationPlayer
var possible_actions := [false, false]

func get_tile_position():
	return current_pos

func is_player() -> bool:
	if data.faction == 0:
		return true
	else:
		return false

func get_movement() -> int:
	return movement

func get_atk_range() -> int:
	return attack_range

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_hp = data.max_hp
	attack = data.attack
	avoid = data.avoid
	luck = data.luck
	movement = data.movement
	attack_range = data.attack_range
	current_hp = data.current_hp
	inventory = data.inventory
	$UnitSprite.texture = data.texture
	$UnitSprite/FistSprite.texture = data.texture
	updateInventory()

func updateInventory():
	if is_player():
		inventory.clear()
		inventory = PWR_Inventory.get_player_items(data.ID)
		print("MY INVENTORY: ", inventory)

func set_tile_position(tile_position : Vector2i):
	global_position = tile_position


func _on_mouse_entered() -> void:
	hovered = true
	levelManager.setEntitySelected(self)


func _on_mouse_exited() -> void:
	hovered = false
	levelManager.setEntitySelected(self)

func set_to_tile(pos : Vector2, tile: Vector2i):
	if levelManager:
		levelManager.camera.focus_on(global_position, false)
	current_pos = tile
	global_position = pos

func get_attack():
	for power in inventory:
		power.on_do_attack(self)
	var crit = false
	luck = clamp(luck, 0, 100)
	var num = randi_range(0,100)
	print(luck, num)
	if num <= luck:
		crit = true
		$SFX/Crit.play_sound(0.2, 1.5)
		var tweem = create_tween()
		modulate = Color(18.892, 18.892, 18.892)
		tweem.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25)
		return [attack * 3, crit]
	return [attack, crit]

func receive_damage(dmg):
	$UnitSprite/Ouch/Label.text = var_to_str(dmg[0])
	$SFX/Hurt.play()
	levelManager.camera.focus_on(global_position, true, Vector2(1.1,1.1))
	avoid = clamp(luck, 0, 100)
	var num = randi_range(0,100)
	if num <= avoid and dmg[1] == false:
		play_animation("avoid")
		await sprite.animation_finished
		emit_signal("done_hurt")
	else:
		for power in inventory:
			power.on_receive_attack(self)
		play_animation("hurt")
		await sprite.animation_finished
		current_hp -= dmg[0]
		levelManager.camera.focus_off()
		if current_hp <= 0:
			$SFX/Dead.play_sound(0.0, 2.0)
			is_alive = false
			$UnitSprite.hide()
			await levelManager.remove_unit(self)
			emit_signal("done_hurt")
		else:
			emit_signal("done_hurt")

func get_alive():
	return is_alive

func start_turn():
	for power in inventory:
		power.on_start_turn(self)
	if is_player():
		return
	levelManager.pathfinding.map.set_point_solid(current_pos, false)
	sprite.play("selected")
	await sprite.animation_finished
	var path = levelManager.get_enemy_target(self)
	var target_pos = path.back()
	path.pop_back()
	path = optimize_path(path, target_pos)
	await traverse_path(path)
	if possible_actions[1] == true:
		perform_attack(levelManager.get_unit(target_pos))
		await sprite.animation_finished
		update_actions(false, false)
		await levelManager.get_unit(target_pos).receive_damage(get_attack())
	levelManager.pathfinding.map.set_point_solid(current_pos, true)
	emit_signal("enemy_done")

func traverse_path(path:Array):
	var timer_walk = Timer.new() 
	add_child(timer_walk)
	timer_walk.wait_time = 0.15
	timer_walk.one_shot = true
	play_animation("walk")
	for tile in path:
		timer_walk.start()
		$SFX/Step.play_sound()
		set_to_tile(levelManager.ground_layer.map_to_local(tile), tile)
		await timer_walk.timeout
		for power in inventory:
			power.on_walk(self)
	
	timer_walk.queue_free()
	sprite.stop()
	update_actions(false, possible_actions[1])
	emit_signal("done_moving")
	if is_player():
		levelManager.camera.focus_off()

func optimize_path(path : Array, target_position):
	path.resize(movement + 1)
	var idx = 1
	print("CHECKING")
	for tile in path:
		if abs(tile.x - target_position.x) + abs(tile.y - target_position.y) <= get_atk_range():
			path.resize(idx)
			update_actions(possible_actions[0], true)
			break
		idx+=1
	return path

func play_animation(anim_name):
	match anim_name:
		"selected":
			if not sprite.is_playing() and hovered == true:
				sprite.play("selected")
				hovered = false
		"hurt":
			sprite.play("hurt")
		"walk":
			sprite.play("walk")
		"punch":
			sprite.play("punch")
		"avoid":
			sprite.play("avoid")

func perform_attack(target):
	$SFX/Hit.play()
	levelManager.camera.focus_on(global_position, true, Vector2(1.1,1.1))
	play_animation("punch")
	await sprite.animation_finished
	levelManager.camera.focus_off()
	emit_signal("done_attacking")
	await target.done_hurt
	if is_player():
		update_actions(false, false)

func reset_actions():
	if is_player():
		update_actions(true, true)
	else:
		update_actions(true, false)

func can_move() -> bool:
	if possible_actions[0] == true:
		return true
	else:
		return false

func can_attack() -> bool:
	if possible_actions[1] == true:
		return true
	else:
		return false


func update_actions(op1:bool, op2:bool):
	possible_actions = [op1, op2]
	if possible_actions == [false, false]:
		for power in inventory:
			power.on_end_turn(self)
		modulate = Color(0.333, 0.333, 0.333, 1.0)
	elif possible_actions == [true, true]:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif possible_actions == [true, false] and !is_player():
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	if is_player():
		levelManager.checkPlayers()

func begin_battle():
	for power in inventory:
		power.on_battle_begin(self)
