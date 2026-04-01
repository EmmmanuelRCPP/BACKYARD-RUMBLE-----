extends Node

var current_level = 1
var money = 5

func add_money(amt:int):
	money += amt

func remove_money(amt:int):
	if money - amt >= 0:
		money -= amt
		return true
	else:
		return false

func reset():
	current_level = 1
	money = 5
	PWR_Inventory.reset_deck()
	PWR_Inventory.reset()
