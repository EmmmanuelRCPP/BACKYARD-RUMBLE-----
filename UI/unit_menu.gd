extends Control

var active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivate()

func activate(can_walk:bool, can_attack:bool)-> void:
	print("BR")
	show()
	$AnimationPlayer.play("appear")
	active = true
	$ButtonContainer/BotonAtaque.disabled = !can_attack
	$ButtonContainer/BotonMovimiento.disabled = !can_walk

func deactivate() -> void:
	$AnimationPlayer.play_backwards("appear")
	hide()
	active = false

func is_active() -> bool:
	return active

func _on_boton_ataque_button_down() -> void:
	pass # Replace with function body.
