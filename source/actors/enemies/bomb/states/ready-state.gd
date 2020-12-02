extends EnemyState



func initialize(argument):
	if animation_player.current_animation != "floating":
		animation_player.play("floating")
		
		# To make them dance in synchrony!
		if enemy.starting_animation_frame < 0:
			animation_player.advance((randi()%40)/10)
		else:
			var converted = int(enemy.starting_animation_frame*10.0)
			animation_player.advance(float(converted%16)/10.0)



func _physics_process(delta):
	if enemy.is_being_sucked():
		enemy.vacuum_suck(delta)
	else:
		enemy.apply_friction(delta)
	
	


