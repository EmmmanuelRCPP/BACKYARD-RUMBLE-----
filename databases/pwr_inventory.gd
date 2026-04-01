extends Node

var p1_items = []
var p2_items = []
var p3_items = []
var p1_items_temp = []
var p2_items_temp = []
var p3_items_temp = []

var deck = []
var d1 = load("res://resources/tres/pwr_resources/Cookie.tres")
var d2 = load("res://resources/tres/pwr_resources/PackedLunch.tres")
var d3 = load("res://resources/tres/pwr_resources/Bandage.tres")
var d4 = load("res://resources/tres/pwr_resources/BaseBallBat.tres")
var d5 = load("res://resources/tres/pwr_resources/Maruto.tres")
func addItem(player_index : int, item):
	if player_index == 1:
		p1_items.append(item)
	elif player_index == 2:
		p2_items.append(item)
	elif player_index == 3:
		p3_items.append(item)

func addTempItem(player_index : int, item):
	if player_index == 1:
		p1_items_temp.append(item)
	elif player_index == 2:
		p2_items_temp.append(item)
	elif player_index == 3:
		p3_items_temp.append(item)

func get_player_items(player_index : int):
	var player_inventory :Array= p1_items.duplicate()
	player_inventory.append_array(p1_items_temp)
	if player_index == 2:
		player_inventory = p2_items.duplicate()
		player_inventory.append_array(p2_items_temp)
	elif player_index == 3:
		player_inventory = p3_items.duplicate()
		player_inventory.append_array(p3_items_temp)
	return player_inventory

func _ready() -> void:
	reset_deck()
	reset()

func reset():
	p1_items.clear()
	p2_items.clear()
	p3_items.clear()
	p1_items_temp.clear()
	p2_items_temp.clear()
	p3_items_temp.clear()
func reset_deck():
	deck.clear()
	for i in 3:
		deck.append(d1)
		deck.append(d2)
		deck.append(d3)
		deck.append(d4)
		deck.append(d5)
func draw_hand(hand_size : int):
	var hand = deck.duplicate()
	hand_size = deck.size() - hand_size
	
	for i in hand_size:
		hand.erase(hand.pick_random())
	
	hand.shuffle()
	return hand
	

func clear_temp_items():
	p1_items_temp.clear()
	p2_items_temp.clear()
	p3_items_temp.clear()
