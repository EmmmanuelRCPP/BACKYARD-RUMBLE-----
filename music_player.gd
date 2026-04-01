extends AudioStreamPlayer

func play_song(songName:String):
	match songName:
		"main":
			stream = load("res://music/rumble (ingame).mp3")
	
	play()

# Called when the node enters the scene tree for the first time.
func play_sfx(sfx_name : String):
	match sfx_name:
		"win":
			$SFX/Win.play_sound()
			GameData.add_money(randi_range(1,10))
		"lose":
			$SFX/Lose.play_sound()

func _ready() -> void:
	play_song("main")
