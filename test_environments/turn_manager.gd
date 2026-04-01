extends Node

enum phase {PLAYER, ENEMY, END, PREPARATIONS, INVENTORY_MANAGEMENT}
var current_phase = phase.PLAYER
@onready var level = get_parent()

func begin_battle():
	current_phase = phase.PREPARATIONS
	level.begin_preparations()

func advance_phase():
	match current_phase:
		phase.PLAYER:
			current_phase = phase.ENEMY
			level.begin_enemy_turn()
		phase.ENEMY:
			current_phase = phase.PLAYER
			level.begin_player_turn()
		phase.PREPARATIONS:
			current_phase = phase.PLAYER
			level.begin_battle()


func _on_preparations_ui_preparation_finished() -> void:
	advance_phase()
