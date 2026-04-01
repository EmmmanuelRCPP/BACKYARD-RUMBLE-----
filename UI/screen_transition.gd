extends CanvasLayer

const LEVELS_PATH1 := "res://Levels/1/"
const LEVELS_PATH2 := "res://Levels/2/"
const LEVELS_PATH3 := "res://Levels/3/"
var levels1: Array = []
var levels2: Array = []
var levels3: Array = []
var l
func _ready() -> void:
	levels1 = [["res://Levels/1/l1.tscn", 0], ["res://Levels/1/l_2.tscn", 0], ["res://Levels/1/l_3.tscn", 0]]
	levels2 = [["res://Levels/2/l_4.tscn", 0], ["res://Levels/2/l_5.tscn", 0], ["res://Levels/2/l_6.tscn", 0]]
	levels3 = [["res://Levels/3/l_7.tscn", 0]]
	l = levels1.duplicate()
	l.append_array(levels2)
	l.append_array(levels3)


func load_levels(LEVELS_PATH, levels):
	levels.clear()
	
	var dir = DirAccess.open(LEVELS_PATH)
	if dir == null:
		push_error("Failed to open Levels folder")
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue
		
		# Only load scene files
		if file_name.ends_with(".tscn"):
			var path = LEVELS_PATH + file_name
			levels.append([path, 0])
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

func change_scene(scene_path:String, type:String):
	print( scene_path)
	print(levels1,levels2,levels3)
	$TextureRect.mouse_filter = 0
	await transition(1.0)
	await display(type)
	get_tree().change_scene_to_file(scene_path)
	await transition(0.0, 0.5)
	$TextureRect.mouse_filter = 2
# Called every frame. 'delta' is the elapsed time since the previous frame

func display(type:String):
	var tween = create_tween()
	match type:
		"win":
			$txt.text = "[wave]LEVEL WON![wave]"
			GameData.current_level += 1
		"level":
			$txt.text = "[wave]DAY: " + var_to_str(GameData.current_level) + "\nONWARD TO THE NEXT FIGHT![wave]"
		"lose":
			$txt.text = "[wave]We'll get them next time...[wave]"
	tween.tween_property($txt, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5) 
	await tween.finished
	tween.stop()
	tween.play()
	tween.tween_property($txt, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5) 
	await tween.finished
	return

func transition(value:float= 1.0, time:float=0.5):
	var tween = create_tween()
	tween.tween_property($TextureRect,"material:shader_parameter/progress", value, time)
	await tween.finished

func enter_level():
	var diff = 0
	if GameData.current_level <= 2:
		diff = 1
		var level = levels1.pick_random()
		while level[1] != 0:
			level = levels1.pick_random()
		change_scene(level[0], "level")
	elif GameData.current_level <= 4:
		diff = 2
		var level = levels2.pick_random()
		while level[1] != 0:
			level = levels2.pick_random()
		change_scene(level[0], "level")
	elif GameData.current_level <= 6:
		diff = 3
		var level = levels3.pick_random()
		while level[1] != 0:
			level = levels3.pick_random()
		change_scene(level[0], "level")
	else:
		var level = l.pick_random()
		change_scene(level[0], "level")
