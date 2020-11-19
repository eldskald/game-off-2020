extends PlayerState



func initialize(argument):
	pity.stop()
	camera.drag_margin_top = 0.05

func exit(next_state):
	if next_state == Player.AIRBORNE_STATE:
		pity.start()



func _physics_process(delta):
	player.horizontal_movement(delta)
	player.vertical_movement(delta)
	
	if Input.is_action_just_pressed("jump"):
		player.change_movement_state(Player.JUMPING_STATE)
	elif not player.is_on_floor():
		player.change_movement_state(Player.AIRBORNE_STATE)
	
	if main.get_just_pressed_dir_input().y == 1:
		player.drop_from_platforms()
