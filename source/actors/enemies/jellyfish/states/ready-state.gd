extends EnemyState



func initialize(argument):
	animation_player.play("floating")
	animation_player.advance((randi()%40)/10)



func _physics_process(delta):
	
	if enemy.is_being_sucked():
		enemy.vacuum_suck(delta)
	else:
		
		# Bobbing up and down animation is calculated to take 1 second to
		# go up, then 3 seconds to go down. Velocity goes up is a function
		# called by the animation player itself.
		if enemy.moving == "Static":
			if enemy.velocity.y >= 0:
				enemy.acceleration = Vector2(0, 32/9)


