extends PlayerState



#func exit(next_state):
#	if next_state == Player.SHOOTING_STATE:
#		player.spawn_shot(player.heavy_shot)
#		gun.spawn_muzzle_flash()
#		player.apply_recoil_knockback(-player.aiming)



func _physics_process(_delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if not Input.is_action_pressed("shoot"):
		player.change_gun_state(Player.READY_STATE)
		player.spawn_shot(player.heavy_shot)
		gun.spawn_muzzle_flash()
		player.apply_recoil_knockback(-player.aiming)


