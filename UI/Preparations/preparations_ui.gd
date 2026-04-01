extends CanvasLayer

var powercard = preload("res://UI/Preparations/power_card.tscn")
@onready var inventory1 = %UnitInventory1 
@onready var inventory2 = %UnitInventory2 
@onready var inventory3 = %UnitInventory3 
@onready var current_inventory = inventory1

signal preparation_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$p1.disabled = true
	$AnimationPlayer.play("shuffle")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("draw")
	await activate()
	$AnimationPlayer.stop()
	current_inventory.show()


func activate():
	show()
	var hand = PWR_Inventory.draw_hand(12)
	for card in hand:
		var tween = create_tween()
		var powercard_instance = powercard.instantiate()
		powercard_instance.hand = true
		powercard_instance.modulate = Color(1.0, 1.0, 1.0, 0.0)
		$Hand.add_child(powercard_instance)
		powercard_instance.activate(card, self)
		tween.tween_property(powercard_instance, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
		await tween.finished

func assign_card(card):
	if card.get_parent().is_in_group("player_inventory"):
		card.reparent($Hand)
	elif current_inventory.get_child_count() < 4:
		card.reparent(current_inventory)




func _on_finish_button_button_down() -> void:
	hide()
	var i = 1
	for tab in $TabContainer.get_children():
		for card in tab.get_children():
			PWR_Inventory.addTempItem(i, card.pow)
			print("k")
		i += 1
	emit_signal("preparation_finished")
	queue_free()


func _on_p_3_button_down() -> void:
	$p2.disabled = false
	$p1.disabled = false
	current_inventory = $%UnitInventory3
	for tab in $TabContainer.get_children():
		tab.hide()
	$TabContainer.get_child(2).show()
	$p3.disabled = true



func _on_p_2_button_down() -> void:
	$p1.disabled = false
	$p3.disabled = false
	current_inventory = $%UnitInventory2
	for tab in $TabContainer.get_children():
		tab.hide()
	$TabContainer.get_child(1).show()
	$p2.disabled = true



func _on_p_1_button_down() -> void:
	$p2.disabled = false
	$p3.disabled = false
	current_inventory = $%UnitInventory1
	for tab in $TabContainer.get_children():
		tab.hide()
	$TabContainer.get_child(0).show()
	$p1.disabled = true

func update_description(name: String, desc : String):
	if $AnimationPlayer.is_playing():
		return
	%Power_Name.text = name
	%Power_Desc.text = desc
	$Description.show()
	$AnimationPlayer.play("select")
