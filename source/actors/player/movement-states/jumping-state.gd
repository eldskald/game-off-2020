extends PlayerState



func initialize():
	coyote.stop()
	bunny.stop()
	player.velocity.y = -player.jump_force
	camera.drag_margin_top = 0.9
	



func _physics_process(delta):
	player.horizontal_movement(delta)
	player.vertical_movement(delta)
	
	if not Input.is_action_pressed("jump") or player.velocity.y >= 0:
		player.velocity.y = max(player.velocity.y, player.jump_force/10)
		machine.change_state(Player.AIRBORNE_STATE)


