extends TextureButton




func _on_button_down() -> void:
	$Click.play_sound()


func _on_mouse_entered() -> void:
	$Hover.play_sound()
