extends PlayerState

var holding = ""
var holding_node
var wall_jump_let_go = false



func initialize(argument):
	holding_node = argument
	if holding_node.get_collision_layer_bit(1) == true: # Solids layer
		holding = "wall"
	elif holding_node.get_collision_layer_bit(4) == true: # Enemies layer
		holding = "enemy"
	elif holding_node.get_collision_layer_bit(5) == true: # Shots layer
		match holding_node.type:
			"Light":
				holding = "shot"
			"Heavy":
				holding = "rocket"




func _physics_process(delta):
	match holding:
		"wall":
			# Dealing with ceilings
			if player.aiming == Vector2.UP:
				if Input.is_action_just_pressed("absorb"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.change_gun_state(Player.READY_STATE)
				elif Input.is_action_just_pressed("jump"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.change_gun_state(Player.READY_STATE)
				elif Input.is_action_just_pressed("shoot"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.change_gun_state(Player.SHOOTING_STATE, 0.2)
					gun.spawn_muzzle_flash()
					player.velocity.y = player.falling_speed
			
			# Dealing with walls
			else:
				if Input.is_action_just_pressed("absorb"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.velocity.x = -player.facing*player.speed
					player.change_gun_state(Player.READY_STATE)
				
				if Input.is_action_just_pressed("jump"):
					pity.start()
					wall_jump_let_go = true
				elif wall_jump_let_go and pity.is_stopped():
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.velocity.x = -player.facing*player.speed
					player.change_gun_state(Player.READY_STATE)
				
				if Input.is_action_just_pressed("shoot"):
					player.change_gun_state(Player.SHOOTING_STATE, 0.2)
					gun.spawn_muzzle_flash()
					player.change_movement_state(Player.WALL_JUMPING_STATE)
					player.velocity.y = -player.jump_force
					
					# Hidden mechanic: if you press jump as you shoot to wall jump,
					# you get more height.
					if pity.is_stopped():
						player.velocity.x = -player.facing*player.speed*2
						pity.start()
					else:
						player.velocity.x = -player.facing*player.speed/2
						pity.stop()
		
		
		
		"enemy":
			if get_pressed_aim_dir() == Vector2.ZERO:
				player.aiming = Vector2(player.facing, 0)
			else:
				player.aiming = get_pressed_aim_dir()
				
			if Input.is_action_just_pressed("shoot"):
				player.change_gun_state(Player.SHOOTING_STATE, 0.2)
				holding_node.shoot(player.aiming)
				player.apply_recoil_knockback(-player.aiming)
			elif Input.is_action_just_pressed("absorb"):
				player.change_gun_state(Player.SHOOTING_STATE, 0.2)
				holding_node.release(player.aiming)
				player.apply_recoil_knockback(Vector2(-player.aiming.x, 0))
		
		
		
		"shot":
			if get_pressed_aim_dir() == Vector2.ZERO:
				player.aiming = Vector2(player.facing, 0)
			else:
				player.aiming = get_pressed_aim_dir()
			
			if Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("absorb"):
				player.change_gun_state(Player.SHOOTING_STATE, 0.2)
				player.spawn_shot(player.heavy_shot)
				gun.spawn_muzzle_flash()
				player.apply_recoil_knockback(-player.aiming)
		
		
		
		"rocket":
			if get_pressed_aim_dir() == Vector2.ZERO:
				player.aiming = Vector2(player.facing, 0)
			else:
				player.aiming = get_pressed_aim_dir()



func is_holding_shot_or_rocket():
	return holding == "shot" or holding == "rocket"




