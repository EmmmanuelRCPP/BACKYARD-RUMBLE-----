extends Control


var max_hp: int
var attack: int
var speed: int
var luck: int 
var current_hp: int
var active = false
var cur_unit
var power_card = preload("res://UI/Preparations/power_card.tscn")


func activate(unit):
	$Description.hide()
	$Activate.play_sound(0.2)
	if unit.is_player():
		$ReadyB.frame = 0
	else:
		$ReadyB.frame = 1
	cur_unit = unit
	show()
	%Name.text = unit.data.unit_name
	%hp.text = "%d" % unit.current_hp
	%speed.text = "%d" % unit.movement
	%attack.text = "%d" % unit.attack
	%luck.text = "%d%%" % unit.luck
	%avoid.text = "%d%%" % unit.avoid
	%range.text = "%d" % unit.attack_range
	$AnimationPlayer.play("appear")
	active = true
	var inv = unit.inventory.duplicate()
	inv.resize(4)
	for i in 4:
		$GridContainer.get_child(i).activate(inv[i], self)

func deactivate():
	$ReadyB.hide()
	cur_unit = null
	$AnimationPlayer.play_backwards("appear")
	if $Description.visible:
		$AnimationPlayer.queue("desc_disappear")
	active = false


func _ready() -> void:
	for i in 4:
		var power_card_instance = power_card.instantiate()
		$GridContainer.add_child(power_card_instance)
	%Power_Name.text = ""
	%Power_Desc.text = ""
	hide()
	deactivate()

func select():
	$Select.play_sound()
	$ReadyB.show()
	$AnimationPlayer.queue("select")

func update_description(name: String, desc : String):
	%Power_Name.text = name
	%Power_Desc.text = desc
	$Description.show()
	$AnimationPlayer.queue("desc_appear")
