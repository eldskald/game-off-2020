extends PlayerState

var timer
onready var dashed = false



func initialize(argument):
	camera.drag_margin_top = 0.05
	
	var dash: Vector2 = Vector2.ZERO
	dash.x = argument.x
	if argument.y == -1:
		dash.y = -2
	else:
		dash.y = -1
	player.velocity = dash*player.speed
	
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(0.3)



func _physics_process(delta):
	player.horizontal_movement(delta, 0.2)
	player.vertical_movement(delta, 0.2)



func _on_timeout():
	if not dashed:
		dashed = true
		player.velocity /= 9
		timer.start(1.0)
	else:
		player.change_movement_state(Player.AIRBORNE_STATE)


