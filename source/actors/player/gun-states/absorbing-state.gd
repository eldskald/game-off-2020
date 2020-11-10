extends PlayerState



func _physics_process(_delta):
	player.aiming = Vector2(player.facing, 0)
	
	if not Input.is_action_pressed("absorb"):
		machine.change_state(Player.READY_STATE)
	
	# Outside an elif statement in case the player shoots without letting
	# go of the absorb button.
	if get_just_pressed_shoot_dir() != Vector2.ZERO:
		player.aiming = get_pressed_shoot_dir()
		machine.change_state(Player.CHARGING_STATE)

