extends PlayerState

onready var suck_area: Area2D = muzzle.get_node("SuckArea")
onready var held_area: Area2D = muzzle.get_node("HeldArea")
onready var left_raycast: RayCast2D = player.get_node("LeftWallFinder")
onready var right_raycast: RayCast2D = player.get_node("RightWallFinder")
onready var up_raycast: RayCast2D = player.get_node("UpWallFinder")



func _physics_process(_delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if not Input.is_action_pressed("absorb"):
		machine.change_state(Player.READY_STATE)
	
	if Input.is_action_just_pressed("shoot"):
		machine.change_state(Player.CHARGING_STATE)
	
	if held_area.get_overlapping_bodies().size() > 0:
		var body = held_area.get_overlapping_bodies()[0]
		
		# Deal with grabbing walls and ceilings.
		if body.get_collision_layer_bit(1) == true: # Solids layer, so it's a wall or ceiling
			if player.get_movement_state() == Player.AIRBORNE_STATE:
				
				# Okay, if the player is in the air and we detected a block, time to
				# find the block and put the player on the correct state.
				if left_raycast.is_colliding():
					player.facing = -1
					player.aiming = Vector2.LEFT
					player.change_movement_state(Player.WALL_GRABBING_STATE)
					machine.change_state(Player.HOLDING_STATE, body)
					
				elif right_raycast.is_colliding():
					player.facing = 1
					player.aiming = Vector2.RIGHT
					player.change_movement_state(Player.WALL_GRABBING_STATE)
					machine.change_state(Player.HOLDING_STATE, body)
					
				elif up_raycast.is_colliding():
					player.aiming = Vector2.UP
					player.change_movement_state(Player.HANGING_STATE)
					machine.change_state(Player.HOLDING_STATE, body)
		
		# Deal with projectiles and enemies.
		else:
			machine.change_state(Player.HOLDING_STATE, body)
	
	


