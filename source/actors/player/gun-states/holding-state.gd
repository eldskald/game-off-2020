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
	
	if holding != "wall" and player.get_movement_state() != Player.GROUNDED_STATE:
		player.change_movement_state(Player.FLOATING_STATE)



func _physics_process(delta):
	match holding:
		"wall":
			# Dealing with ceilings
			if player.aiming == Vector2.UP:
				if Input.is_action_just_pressed("absorb"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					machine.change_state(Player.READY_STATE)
				elif Input.is_action_just_pressed("jump"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					machine.change_state(Player.READY_STATE)
				elif Input.is_action_just_pressed("shoot"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					machine.change_state(Player.SHOOTING_STATE, 0.2)
					gun.spawn_muzzle_flash()
					player.velocity.y = player.falling_speed
			
			# Dealing with walls
			else:
				if Input.is_action_just_pressed("absorb"):
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.velocity.x = -player.facing*player.speed
					machine.change_state(Player.READY_STATE)
				
				if Input.is_action_just_pressed("jump"):
					pity.start()
					wall_jump_let_go = true
				elif wall_jump_let_go and pity.is_stopped():
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.velocity.x = -player.facing*player.speed
					machine.change_state(Player.READY_STATE)
				
				if Input.is_action_just_pressed("shoot"):
					machine.change_state(Player.SHOOTING_STATE, 0.2)
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
			pass
		
		"shot":
			pass
		
		"rocket":
			pass



#func shoot_and_knockback(shoot_duration: float):
#	if not Input.is_action_pressed("absorb"):
#		var next = machine.change_state(Player.SHOOTING_STATE, true)
#		next.duration = shoot_duration
#		next.initialize()
#
#		# Same code from charged state
#		if player.get_movement_state() != Player.GROUNDED_STATE:
#			player.change_movement_state(Player.AIRBORNE_STATE)
#			player.velocity.y = min(-player.jump_force/3, player.velocity.y)
#			if player.velocity.x > 0:
#				player.velocity.x = -player.speed*player.aiming.x
#			else:
#				player.velocity.x = -2*player.speed*player.aiming.x
#
#	if get_just_pressed_shoot_dir() != Vector2.ZERO:
#		player.aiming = get_just_pressed_shoot_dir()
#		var next = machine.change_state(Player.SHOOTING_STATE, true)
#		next.duration = shoot_duration
#		next.initialize()
#
#		# Same code from charged state
#		if player.aiming == Vector2.DOWN:
#			player.change_movement_state(Player.AIRBORNE_STATE)
#			player.velocity.y = -player.jump_force
#		elif player.get_movement_state() != Player.GROUNDED_STATE:
#			player.change_movement_state(Player.AIRBORNE_STATE)
#			if player.aiming == Vector2.UP:
#				player.velocity.y += player.falling_speed
#			else:
#				player.velocity.y = min(-player.jump_force/3, player.velocity.y)
#				if player.velocity.x > 0:
#					player.velocity.x = -player.speed*player.aiming.x
#				else:
#					player.velocity.x = -2*player.speed*player.aiming.x



func is_holding_shot():
	return holding == "shot"

func is_holding_enemy():
	return holding == "enemy"

func is_holding_wall():
	return holding == "wall"

func is_holding_rocket():
	return holding == "rocket"




