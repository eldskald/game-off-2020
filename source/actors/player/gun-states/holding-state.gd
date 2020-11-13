extends PlayerState

var holding_node = null
var holding = ""

func initialize():
	if holding_node.get_collision_layer_bit(1) == true: # Solids layer
		player.change_movement_state(Player.WALL_GRABBING_STATE)
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
	player.aiming = Vector2(player.facing, 0)
	
	match holding:
		"wall":
			if not Input.is_action_pressed("absorb"):
				player.change_movement_state(Player.AIRBORNE_STATE)
				player.velocity.x = -player.facing*player.speed
				machine.change_state(Player.READY_STATE)
			
			if get_just_pressed_shoot_dir() != Vector2.ZERO:
				
				# Non wall jump cases
				if get_just_pressed_shoot_dir() in [Vector2.UP, Vector2(-player.facing, 0)]:
					player.aiming = get_just_pressed_shoot_dir()
					machine.change_state(Player.CHARGING_STATE)
					player.change_movement_state(Player.AIRBORNE_STATE)
					player.velocity.x = -player.facing*player.speed
				
				# Jump away case
				elif get_just_pressed_shoot_dir() == Vector2(player.facing, 0):
					player.aiming = get_just_pressed_shoot_dir()
					var next = machine.change_state(Player.SHOOTING_STATE, true)
					next.duration = 0.2
					next.initialize()
					player.change_movement_state(Player.WALL_JUMPING_STATE)
					player.velocity.x = -player.facing*player.speed*2
					player.velocity.y = -player.jump_force
					pity.start()
				
				# Jump up case
				elif get_just_pressed_shoot_dir() == Vector2.DOWN:
					player.aiming = get_just_pressed_shoot_dir()
					var next = machine.change_state(Player.SHOOTING_STATE, true)
					next.duration = 0.2
					next.initialize()
					player.change_movement_state(Player.WALL_JUMPING_STATE)
					player.velocity.x = -player.facing*player.speed
					player.velocity.y = -player.jump_force
		
		"enemy":
			shoot_and_knockback(0.5)
		
		"shot":
			shoot_and_knockback(0.2)
		
		"rocket":
			pass



func shoot_and_knockback(shoot_duration: float):
	if not Input.is_action_pressed("absorb"):
		var next = machine.change_state(Player.SHOOTING_STATE, true)
		next.duration = shoot_duration
		next.initialize()
		
		# Same code from charged state
		if player.get_movement_state() != Player.GROUNDED_STATE:
			player.change_movement_state(Player.AIRBORNE_STATE)
			player.velocity.y = min(-player.jump_force/3, player.velocity.y)
			if player.velocity.x > 0:
				player.velocity.x = -player.speed*player.aiming.x
			else:
				player.velocity.x = -2*player.speed*player.aiming.x
	
	if get_just_pressed_shoot_dir() != Vector2.ZERO:
		player.aiming = get_just_pressed_shoot_dir()
		var next = machine.change_state(Player.SHOOTING_STATE, true)
		next.duration = shoot_duration
		next.initialize()
		
		# Same code from charged state
		if player.aiming == Vector2.DOWN:
			player.change_movement_state(Player.AIRBORNE_STATE)
			player.velocity.y = -player.jump_force
		elif player.get_movement_state() != Player.GROUNDED_STATE:
			player.change_movement_state(Player.AIRBORNE_STATE)
			if player.aiming == Vector2.UP:
				player.velocity.y += player.falling_speed
			else:
				player.velocity.y = min(-player.jump_force/3, player.velocity.y)
				if player.velocity.x > 0:
					player.velocity.x = -player.speed*player.aiming.x
				else:
					player.velocity.x = -2*player.speed*player.aiming.x



func is_holding_shot():
	return holding == "shot"

func is_holding_enemy():
	return holding == "enemy"

func is_holding_wall():
	return holding == "wall"

func is_holding_rocket():
	return holding == "rocket"




