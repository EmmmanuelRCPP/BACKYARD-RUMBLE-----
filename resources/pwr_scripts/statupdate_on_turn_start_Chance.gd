extends PowerData
class_name Stat_Update_turn_start_chance

var activated = false
func on_start_turn(unit):
	if activated:
		set_inverse_stat_changes(unit)
		activated = false
	var num = randi_range(1, 100)
	if num <= max_hp:
		activated = true
		set_stat_changes(unit)
		print("CHARM ACTIVE")

func on_end_turn(unit):
	if activated:
		set_inverse_stat_changes(unit)
		activated = false
