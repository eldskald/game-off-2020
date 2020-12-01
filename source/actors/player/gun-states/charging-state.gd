extends PlayerState



func initialize(argument):
	charge.connect("timeout", self, "finish_charging")
	charge.start()
	gun.charge_particles_timer.start()
	sfx.charge(true)

func exit(next_state):
	cooldown.start()
	if next_state != Player.CHARGED_STATE:
		sfx.charge(false)



func _physics_process(_delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if not Input.is_action_pressed("shoot"):
		player.change_gun_state(Player.READY_STATE)
		player.spawn_shot(player.light_shot)
		gun.spawn_muzzle_flash()
		sfx.shot()
		
		# Keeping the player afloat when shooting downwards.
		if player.aiming.y == 1 and player.get_movement_state() == Player.AIRBORNE_STATE:
			if player.velocity.y > 0 and player.velocity.y <= player.jump_force/3:
				player.velocity.y *= -0.5
			elif player.velocity.y > player.jump_force/3:
				player.velocity.y = -player.jump_force/3



func finish_charging():
	player.change_gun_state(Player.CHARGED_STATE)

