extends PlayerState

var target_location
var timer
onready var reached_target = false



func initialize(argument):
	camera.drag_margin_top = 0.05
	target_location = argument
	player.velocity = (target_location - player.position).normalized()*player.speed
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "over")



func _physics_process(delta):
	if not reached_target:
		if (player.position - target_location).length_squared() < 25:
			reached_target = true
			player.velocity /= 3
			timer.start(1.0)
	else:
		player.horizontal_movement(delta, 0.2)
		player.vertical_movement(delta, 0.1)



func over():
	machine.change_state(Player.AIRBORNE_STATE)


