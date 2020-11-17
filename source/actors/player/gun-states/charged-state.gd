extends PlayerState



func exit(next_state):
	if next_state == Player.SHOOTING_STATE:
		player.spawn_shot(player.heavy_shot)
		gun.spawn_muzzle_flash()
		
		# Double jump like shot.
		if player.aiming.y == 1:
			player.change_movement_state(Player.AIRBORNE_STATE)
			player.velocity.y = -player.jump_force
			if player.aiming.x != 0:
				if player.velocity.x > 0:
					player.velocity.x = -player.speed*player.aiming.x
				else:
					player.velocity.x = -2*player.speed*player.aiming.x
		
		# Other knockback effects of the heavy shot.
		elif player.get_movement_state() != Player.GROUNDED_STATE:
			player.change_movement_state(Player.AIRBORNE_STATE)
			if player.aiming.y == -1:
				player.velocity.y += player.falling_speed
			else:
				player.velocity.y = min(-player.jump_force/1.41421, player.velocity.y)
			if player.aiming.x != 0:
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
		player.change_gun_state(Player.SHOOTING_STATE, 0.2)


