extends EnemyState

var timer



func initialize(argument):
	
	# Timer for the hydra to start charging its shot.
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(1 + (randi()%10)/10)
	
	# Get the animation right.
	if animation_player.current_animation != "ready":
		animation_player.play("ready", -1, 1 + (randi()%10)/10)
		animation_player.advance((randi()%30)/10)



func _physics_process(delta):
	if enemy.is_being_sucked():
		enemy.vacuum_suck(delta)
	else:
		enemy.horizontal_movement(delta)
		enemy.vertical_movement(delta)



func _on_timeout():
	enemy.change_state(enemy.CHARGING_STATE)


