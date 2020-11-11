extends PlayerState



func initialize():
	charge.connect("timeout", self, "finish_charging")
	charge.start()
	gun.charge_particles_timer.start()

func exit(next_state):
	if next_state == Player.SHOOTING_STATE:
		player.spawn_shot(player.light_shot)
		gun.spawn_muzzle_flash()
		
		# Keeping the player afloat code.
		if player.aiming == Vector2.DOWN and player.get_movement_state() == Player.AIRBORNE_STATE:
			player.velocity.y = min(-player.jump_force/5, player.velocity.y)



func _physics_process(_delta):
	if get_pressed_shoot_dir() == Vector2.ZERO:
		var next = machine.change_state(Player.SHOOTING_STATE, true)
		next.duration = 0.2
		next.initialize()
	else:
		player.aiming = get_pressed_shoot_dir()
	
	# Outside an elif statement in case the player presses the absorb
	# button without letting go of the shoot button.
	if Input.is_action_just_pressed("absorb"):
		player.aiming = Vector2(player.facing, 0)
		machine.change_state(Player.ABSORBING_STATE)



func finish_charging():
	machine.change_state(Player.CHARGED_STATE)

