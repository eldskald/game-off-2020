extends PlayerState

var target_location: Vector2 = Vector2.ZERO
var timer
onready var reached_target = false



func initialize(argument):
	camera.drag_margin_top = 0.05
	
	target_location = player.position
	if argument.y == -1:
		target_location.y -= 16
	if argument.x != 0:
		target_location.x += 16*argument.x
	player.velocity = (target_location - player.position).normalized()*player.speed*3
	
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_timeout")



func _physics_process(delta):
	if not reached_target:
		if (player.position - target_location).length_squared() <= 25:
			reached_target = true
			player.velocity /= 9
			timer.start(1.0)
	else:
		player.horizontal_movement(delta, 0.2)
		player.vertical_movement(delta, 0.1)



func _on_timeout():
	player.change_movement_state(Player.AIRBORNE_STATE)


