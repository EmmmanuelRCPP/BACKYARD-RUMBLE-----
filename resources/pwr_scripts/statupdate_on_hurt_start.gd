extends PowerData
class_name Stat_Update_onHurt

func on_receive_attack(unit):
	set_stat_changes(unit)
	print("CHARM ACTIVE")
