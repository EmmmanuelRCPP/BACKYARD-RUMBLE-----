extends Node

var DB : UnitDatabase = load("res://resources/tres/unit_database.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DB.build()
