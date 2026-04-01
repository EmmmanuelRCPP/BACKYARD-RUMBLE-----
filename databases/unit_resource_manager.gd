extends Resource
class_name UnitDatabase

# List of all units
@export var units: Array[UnitData] = []

# Internal lookup (built at runtime)
var _unit_map: Dictionary = {}

# Build dictionary (call this once)
func build():
	_unit_map.clear()
	for unit in units:
		if unit == null:
			continue
		_unit_map[unit.ID] = unit

# Get unit by string ID
func get_unit(id: int) -> UnitData:
	return _unit_map.get(id, null)
