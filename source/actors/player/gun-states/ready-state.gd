extends PlayerState



func _physics_process(delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if Input.is_action_just_pressed("shoot"):
		machine.change_state(Player.CHARGING_STATE)
	elif Input.is_action_just_pressed("absorb"):
		machine.change_state(Player.ABSORBING_STATE)



