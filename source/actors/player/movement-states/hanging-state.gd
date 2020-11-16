extends PlayerState

# This state is almost entirely handled by the holding state script.
# Look at it to see how wall jumping works in detail.



onready var raycast: RayCast2D = player.get_node("UpWallFinder")

func initialize(argument):
	camera.drag_margin_top = 0.05
	raycast.force_raycast_update()
	player.velocity = Vector2.ZERO
	if raycast.is_colliding():
		
		# Calculating the point of contact on coordinates local to
		# the level, and positioning the player accordingly.
		var point = player.get_parent().to_local(raycast.get_collision_point())
		player.position.y = point.y + 19
	
	# Just in case something horrible happens and the player gets into
	# wall grabbing state without the raycast colliding somehow, better
	# go to airborne and ready states than have the game crash.
	else:
		player.change_movement_state(Player.AIRBORNE_STATE)
		player.change_gun_state(Player.READY_STATE)
