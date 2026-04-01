extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Sprite2D.global_position = event.global_position
