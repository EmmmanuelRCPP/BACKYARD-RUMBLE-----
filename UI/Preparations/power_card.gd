extends TextureButton

var shop = false
var hand = false
var deck = false
var manager
var pow
# Called when the node enters the scene tree for the first time.
func activate(power:PowerData, manager_node = null):
	print(power)
	if power:
		manager = manager_node
		$Sprite2D.texture = power.icon
		pow = power
		show()
	else:
		hide()


func _on_button_down() -> void:
	if hand and !shop:
		manager.assign_card(self)
	if !hand and shop:
		manager.buy(self)
	if deck:
		manager.replace(self)


func _on_mouse_entered() -> void:
	$Hover.play_sound(0.3)
	if manager == null:
		return
	if !hand and !shop:
		manager.update_description(pow.power_name, pow.description)
	elif hand and !shop:
		manager.update_description(pow.power_name, pow.description)
	elif shop:
		manager.update_description(pow.power_name, pow.description)
