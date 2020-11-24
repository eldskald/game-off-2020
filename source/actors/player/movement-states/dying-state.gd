extends PlayerState



func initialize(argument):
	player.velocity = Vector2(-player.facing, -1)*200
	player.invincibility.connect("timeout", self, "_on_timeout")
	player.invincibility.start()
	player.get_node("Sprite/DeathParticles1").emitting = true
	player.get_node("Sprite/DeathParticles2").emitting = true
	player.get_node("Sprite/DeathParticles3").emitting = true



func _physics_process(delta):
	player.vertical_movement(delta)
	if player.velocity.y >= 0:
		player.velocity.x -= delta*player.friction/2
		player.vertical_movement(delta, 0.2)



func _on_timeout():
	main.player_died()

