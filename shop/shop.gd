extends CanvasLayer

var selected_card = null
var cardd = preload("res://UI/Preparations/power_card.tscn")
var c = null
var p = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var idx = 0
	for i in $Items_on_sale.get_children():
		i.shop = true
		i.activate(PowerDb.DB.get_random_power(), self)
		$Prices.get_child(idx).text = var_to_str(i.pow.price) + "$"
		idx += 1
	var deck = PWR_Inventory.deck.duplicate()
	idx = 0
	for i in $GridContainer.get_children():
		i.shop = true
		i.deck = true
		i.activate(deck[idx], self)
		idx += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Cash.text = "Cash: "+ var_to_str(GameData.money) + "$"

func update_description(power_name, description):
	$Desc.text = description
	$Name.text = power_name

func buy(card):
	if card.deck:
		return
	if card.pow.price <= GameData.money:
		GameData.add_money(-card.pow.price)
		$SFXPlayer.play_sound(0.1)
		$Order.text = "Choose a card to remove in otder to add your purchase"
		c = cardd.instantiate()
		selected_card = card
	else:
		$No.play_sound(0.1)

func replace(card):
	if selected_card == null:
		return
	card.queue_free()
	c.shop = true
	c.deck = true
	$GridContainer.add_child(c)
	c.activate(selected_card.pow, self)
	print(c.pow.power_name)
	$Order.text = "Buy new PWRs"
	selected_card = null


func _on_boton_ataque_button_down() -> void:
	var deck = []
	for i in $GridContainer.get_children():
		deck.append(i.pow)
		print(i.pow.power_name)
	PWR_Inventory.deck = deck
	ScreenTransition.enter_level()
