extends PlayerState



func initialize(argument):
	pity.stop()
	player.velocity.y = -player.jump_force
	camera.drag_margin_top = 0.7
	sfx.jump()



func _physics_process(delta):
	player.horizontal_movement(delta)
	player.vertical_movement(delta)
	
	if not Input.is_action_pressed("jump") or player.velocity.y >= 0:
		player.velocity.y = max(player.velocity.y, player.jump_force/10)
		player.change_movement_state(Player.AIRBORNE_STATE)


