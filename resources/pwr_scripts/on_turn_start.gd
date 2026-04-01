extends PowerData
class_name Stat_Update

func on_start_turn(unit):
	set_stat_changes(unit)
	print("CHARM ACTIVE")
