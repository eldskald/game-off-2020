extends PlayerState



func _physics_process(delta):
	player.aiming = Vector2(player.facing, 0)
	
	if get_pressed_shoot_dir() != Vector2.ZERO:
		player.aiming = get_pressed_shoot_dir()
		machine.change_state(Player.CHARGING_STATE)
	elif Input.is_action_pressed("absorb"):
		machine.change_state(Player.ABSORBING_STATE)



