extends Resource
class_name PowerDatabase


const PWR_PATHS := ["res://resources/tres/pwr_resources/Bandage.tres",
"res://resources/tres/pwr_resources/BaseBallBat.tres",
"res://resources/tres/pwr_resources/Cloak.tres",
"res://resources/tres/pwr_resources/Cookie.tres",
"res://resources/tres/pwr_resources/Dad's Pills.tres",
"res://resources/tres/pwr_resources/Dice.tres",
"res://resources/tres/pwr_resources/Energy Rush.tres",
"res://resources/tres/pwr_resources/ExpiredSoda.tres",
"res://resources/tres/pwr_resources/HappyHour.tres",
"res://resources/tres/pwr_resources/Healthy Lunch.tres",
"res://resources/tres/pwr_resources/JunkFood.tres",
"res://resources/tres/pwr_resources/Maruto.tres",
"res://resources/tres/pwr_resources/PackedLunch.tres",
"res://resources/tres/pwr_resources/PBJ.tres",
"res://resources/tres/pwr_resources/Rage.tres",
"res://resources/tres/pwr_resources/Real Rage.tres",
"res://resources/tres/pwr_resources/Regeneration.tres",
"res://resources/tres/pwr_resources/Running Shoes.tres",
"res://resources/tres/pwr_resources/Sentinel.tres",
"res://resources/tres/pwr_resources/Slingshot.tres",
"res://resources/tres/pwr_resources/snowball.tres",
"res://resources/tres/pwr_resources/Teleport.tres",
"res://resources/tres/pwr_resources/Vampire.tres",
"res://resources/tres/pwr_resources/Workout Tape.tres",
"res://resources/tres/pwr_resources/Yoyo.tres"]
# Internal lookup (built at runtime)

# Build dictionary (call this once)
var PWRs: Array[PowerData] = []
var _PWR_map: Dictionary = {}

func build():
	PWRs.clear()
	_PWR_map.clear()
	
	var i = 0
	
	for path in PWR_PATHS:
		var PWR = load(path)
		
		if PWR == null:
			push_error("Failed to load: " + path)
			continue
		
		PWRs.append(PWR)
		
		PWR.ID = i
		_PWR_map[i] = PWR
		
		i += 1

# Get unit by string ID
func get_PWR(id: int) -> PowerData:
	return _PWR_map.get(id, null)

func get_random_power():
	return PWRs.pick_random()
