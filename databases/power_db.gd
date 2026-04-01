extends  Node
var DB : PowerDatabase = load("res://resources/tres/power_database.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DB.build()
