extends PlayerState



func initialize(argument):
	charge.connect("timeout", self, "finish_charging")
	charge.start()
	gun.charge_particles_timer.start()

func exit(next_state):
	if next_state == Player.SHOOTING_STATE:
		player.spawn_shot(player.light_shot)
		gun.spawn_muzzle_flash()
		
		# Keeping the player afloat code.
		if player.aiming.y == 1 and player.get_movement_state() == Player.AIRBORNE_STATE:
			player.velocity.y = min(-player.jump_force/4, player.velocity.y)



func _physics_process(_delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if not Input.is_action_pressed("shoot"):
		machine.change_state(Player.SHOOTING_STATE, 0.1)
	
	if Input.is_action_just_pressed("absorb"):
		machine.change_state(Player.ABSORBING_STATE)



func finish_charging():
	machine.change_state(Player.CHARGED_STATE)

