extends Resource
class_name UnitData

enum faction_types{PLAYER, ENEMY}

# --- Basic Info ---
@export var unit_name: String = "Unit"
@export var faction = faction_types.PLAYER # Player / Enemy / NPC
@export var ID = 0
# --- Core Stats ---
@export var max_hp: int = 20
@export var attack: int = 5
@export var avoid: int = 5
@export var luck: int = 0
@export var movement: int = 5
@export var attack_range: int = 1
# --- Current State ---
@export var current_hp: int = 20

@export var inventory: Array[Resource] = []
@export var texture : Texture
# --- Position (grid-based) ---
@export var grid_position: Vector2i
