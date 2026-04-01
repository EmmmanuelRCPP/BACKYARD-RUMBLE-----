extends PowerData
class_name Stat_Update_turn_and_battle

@export var hp2 = 0
@export var attack2 = 0
@export var movement2 = 0
@export var luck2 = 0
@export var avoid2 = 0
@export var range2 = 0

func set_stat_changes2(unit):
	unit.current_hp += hp2
	unit.attack += attack2
	unit.avoid += avoid2
	unit.luck += luck2
	unit.attack_range += range2
	unit.movement += movement2
	clamp_val(unit)

func on_start_turn(unit):
	set_stat_changes2(unit)
	print("CHARM ACTIVE")

func on_battle_begin(unit):
	set_stat_changes(unit)
	print("CHARM ACTIVE")
