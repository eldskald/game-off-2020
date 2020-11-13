extends PlayerState



func exit(next_state):
	if next_state == Player.SHOOTING_STATE:
		player.spawn_shot(player.heavy_shot)
		gun.spawn_muzzle_flash()
		
		# Double jump like shot.
		if player.aiming == Vector2.DOWN:
			player.change_movement_state(Player.AIRBORNE_STATE)
			player.velocity.y = -player.jump_force
		
		# Other knockback effects of the heavy shot.
		elif player.get_movement_state() != Player.GROUNDED_STATE:
			player.change_movement_state(Player.AIRBORNE_STATE)
			if player.aiming == Vector2.UP:
				player.velocity.y += player.falling_speed
			else:
				player.velocity.y = min(-player.jump_force/3, player.velocity.y)
				if player.velocity.x > 0:
					player.velocity.x = -player.speed*player.aiming.x
				else:
					player.velocity.x = -2*player.speed*player.aiming.x



func _physics_process(_delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if not Input.is_action_pressed("shoot"):
		var next = machine.change_state(Player.SHOOTING_STATE, true)
		next.duration = 0.2
		next.initialize()
	
	if Input.is_action_just_pressed("absorb"):
		player.aiming = Vector2(player.facing, 0)
		machine.change_state(Player.ABSORBING_STATE)



