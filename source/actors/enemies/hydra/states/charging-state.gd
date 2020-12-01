extends EnemyState

var timer

onready var charge_particles = enemy.get_node("ChargeParticles")
onready var charge_ball = enemy.get_node("ChargeBall")



func initialize(argument):
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(0.5)
	
	# Get the animation right.
	sfx.get_node("Charge").play()
	charge_particles.emitting = true
	charge_ball.visible = false
	if animation_player.current_animation != "ready":
		animation_player.play("ready", -1, 1 + (randi()%10)/10)
		animation_player.advance((randi()%30)/10)



func exit(next_state):
	charge_particles.restart()
	charge_particles.emitting = false
	charge_ball.visible = false
	sfx.get_node("Charge").stop()



func _physics_process(delta):
	if enemy.is_being_sucked():
		enemy.vacuum_suck(delta)
	else:
		enemy.horizontal_movement(delta)
		enemy.vertical_movement(delta)



func _on_timeout():
	if charge_ball.visible == false:
		charge_ball.visible = true
		timer.start(0.5)
	else:
		enemy.spawn_shot(enemy.get_shot_dir_vector())
		enemy.change_state(enemy.READY_STATE)


