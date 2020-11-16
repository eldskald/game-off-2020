extends PlayerState



func _physics_process(delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if Input.is_action_just_pressed("shoot"):
		player.change_gun_state(Player.CHARGING_STATE)
	elif Input.is_action_just_pressed("absorb"):
		player.change_gun_state(Player.ABSORBING_STATE)



