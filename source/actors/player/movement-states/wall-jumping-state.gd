extends PlayerState



func exit(next_state):
	pity.stop()



func _physics_process(delta):
	
	# Make acceleration slower to make it harder to scale walls.
	player.horizontal_movement(delta, 0.4)
	player.vertical_movement(delta, 1.0)
	
	# Hidden mechanic: pressing the jump button as you shoot to wall jump
	# away gives you more height.
	if Input.is_action_just_pressed("jump") and not pity.is_stopped():
		player.velocity.x /= 4
	
	# Leaving this state.
	if player.velocity.y >= 0:
		machine.change_state(Player.AIRBORNE_STATE)


