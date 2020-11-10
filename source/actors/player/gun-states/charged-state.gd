extends PlayerState



func exit(next_state):
	if next_state == Player.SHOOTING_STATE:
		player.spawn_shot(player.heavy_shot)
		gun.spawn_particles(gun.heavy_shot_particles)
		
		# Double jump like shot.
		if player.aiming == Vector2.DOWN:
			player.velocity.y = -player.jump_force
		
		# Other knockback effects of the heavy shot.
		elif player.get_movement_state() in [Player.JUMPING_STATE, Player.AIRBORNE_STATE]:
			if player.aiming == Vector2.UP:
				player.velocity.y += player.falling_speed
			else:
				player.velocity -= Vector2(player.speed*player.aiming.x, player.jump_force/10)



func _physics_process(_delta):
	if get_pressed_shoot_dir() == Vector2.ZERO:
		var next = machine.change_state(Player.SHOOTING_STATE, true)
		next.duration = 0.1
		next.initialize()
	else:
		player.aiming = get_pressed_shoot_dir()
	
	# Outside an elif statement in case the player presses the absorb
	# button without letting go of the shoot button.
	if Input.is_action_just_pressed("absorb"):
		player.aiming = Vector2(player.facing, 0)
		machine.change_state(Player.ABSORBING_STATE)



