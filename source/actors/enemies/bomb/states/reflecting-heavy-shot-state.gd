extends EnemyState

var timer
var direction: Vector2 = Vector2.ZERO



func initialize(argument):
	direction = argument
	sprite.get_material().set_shader_param("flash_yellow", 1.0)
	sprite.get_node("ChargeParticles").emitting = true
	animation_player.stop(false)
	sfx.get_node("Charge").play()
	enemy.velocity = Vector2.ZERO
	
	timer = Timer.new()
	enemy.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(1.0)



func exit(next_state):
	animation_player.play("floating")
	sprite.get_material().set_shader_param("flash_yellow", 0.0)
	sprite.get_node("ChargeParticles").restart()
	sprite.get_node("ChargeParticles").emitting = false
	sfx.get_node("Charge").stop()



func _on_timeout():
	enemy.spawn_shot(enemy.heavy_shot, direction)
	enemy.change_state(enemy.READY_STATE)



func _physics_process(delta):
	if enemy.is_being_sucked():
		enemy.vacuum_suck(delta)
	else:
		enemy.apply_friction(delta)


