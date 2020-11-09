extends PlayerState



func initialize():
	bunny.stop()
	camera.drag_margin_top = 0.05

func exit(next_state):
	if next_state == Player.AIRBORNE_STATE:
		coyote.start()



func _physics_process(delta):
	player.horizontal_movement(delta)
	player.vertical_movement(delta)
	
	if Input.is_action_just_pressed("jump"):
		machine.change_state(Player.JUMPING_STATE)
	elif not player.is_on_floor():
		machine.change_state(Player.AIRBORNE_STATE)
