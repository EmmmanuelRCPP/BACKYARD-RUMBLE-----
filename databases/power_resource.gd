extends Resource
class_name PowerData

# --- Basic Info ---
@export var power_name: String = "Power"
@export var ID = 0
# --- Core Stats ---
@export var hp: int = 20
@export var max_hp: int = 20
@export var attack: int = 5
@export var avoid: int = 5
@export var luck: int = 0
@export var movement: int = 5
@export var attack_range: int = 1

@export var effects := []
@export var icon :Texture
@export var description: String
@export var price:= 5

var stats := [hp, max_hp, attack, avoid, luck, movement, attack_range]
func on_start_turn(unit):
	pass

func on_end_turn(unit):
	pass

func on_death(unit):
	pass

func on_battle_begin(unit):
	pass

func on_do_attack(unit):
	pass

func on_receive_attack(unit):
	pass

func on_walk(unit):
	pass

func set_stat_changes(unit):
	unit.current_hp += hp
	unit.attack += attack
	unit.avoid += avoid
	unit.luck += luck
	unit.attack_range += attack_range
	unit.movement += movement
	clamp_val(unit)

func set_inverse_stat_changes(unit):
	unit.current_hp -= hp
	unit.attack -= attack
	unit.avoid -= avoid
	unit.luck -= luck
	unit.attack_range -= attack_range
	unit.movement -= movement
	clamp_val(unit)

func clamp_val(unit):
	if unit.current_hp < 1:
		unit.current_hp = 1
	elif unit.current_hp > 999:
		unit.current_hp = 999

	if unit.attack < 1:
		unit.attack = 1
	elif unit.attack > 999:
		unit.attack = 999

	if unit.avoid < 0:
		unit.avoid = 0
	elif unit.avoid > 100:
		unit.avoid = 100

	if unit.luck < 1:
		unit.luck = 1
	elif unit.luck > 100:
		unit.luck = 100

	if unit.attack_range < 1:
		unit.attack_range = 1
	elif unit.attack_range > 20:
		unit.attack_range = 20

	if unit.movement < 0:
		unit.movement = 0
	elif unit.movement > 20:
		unit.movement = 20
