extends PlayerState

var timer
var duration: float = 1.0
var pressed_shoot: bool = false
var pressed_absorb: bool = false



func initialize():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "over")
	timer.start(duration)



func _physics_process(_delta):
	if timer.wait_time - timer.time_left > 0:
		if get_just_pressed_shoot_dir() != Vector2.ZERO:
			pressed_shoot = true
		if Input.is_action_just_pressed("absorb"):
			pressed_absorb = true



func over():
	if Input.is_action_pressed("absorb") and pressed_absorb:
		machine.change_state(Player.ABSORBING_STATE)
	elif get_pressed_shoot_dir() != Vector2.ZERO and pressed_shoot:
		player.aiming = get_pressed_shoot_dir()
		machine.change_state(Player.CHARGING_STATE)
	else:
		machine.change_state(Player.READY_STATE)


