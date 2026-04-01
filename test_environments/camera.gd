extends Camera2D

var moving = false
var focus = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and moving and !focus:
		position -= event.relative
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(0.1, 0.1)
			zoom.x = clamp(zoom.x, 0.5, 1.5)
			zoom.y = clamp(zoom.y, 0.5, 1.5)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(0.1, 0.1)
			zoom.x = clamp(zoom.x, 0.5, 1.5)
			zoom.y = clamp(zoom.y, 0.5, 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		moving = true
	elif Input.is_action_just_released("back"):
		moving = false

func focus_on(target:Vector2, will_zoom :bool= true, zoom_q = Vector2(1.1,1.1)):
	if target == null:
		return
	if will_zoom:
		var zoom_tween = create_tween()
		zoom_tween.tween_property(self, "zoom", zoom_q, 0.3)
		focus = true
	self.global_position = target

func focus_off():
	var zoom_tween = create_tween()
	zoom_tween.tween_property(self, "zoom", Vector2(1,1), 0.3)
	focus = false
