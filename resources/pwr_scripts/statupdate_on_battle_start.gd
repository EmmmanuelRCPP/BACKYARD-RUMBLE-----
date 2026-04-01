extends PowerData
class_name Stat_Update_Battle_Start

func on_battle_begin(unit):
	set_stat_changes(unit)
	print("CHARM ACTIVE")
