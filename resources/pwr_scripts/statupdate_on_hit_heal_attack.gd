extends PowerData
class_name Stat_Update_onHit_HealAttack
var activated
func on_do_attack(unit):
	unit.current_hp += unit.attack
