extends AudioStreamPlayer


func play_sound(variation = 0.1, std = 1.0):
	pitch_scale = randf_range((std - variation), (std + variation))
	play()
