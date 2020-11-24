extends PlayerState



func initialize(argument):
	camera.drag_margin_top = 0.05
	player.velocity = Vector2(-player.facing, -1)*150
	player.invincibility.connect("timeout", self, "_on_timeout")
	player.invincibility.start()
	player.get_node("Sprite/DeathParticles1").emitting = true
	player.get_node("Sprite/DeathParticles2").emitting = true
	player.get_node("Sprite/DeathParticles3").emitting = true



func _physics_process(delta):
	player.vertical_movement(delta, 0.2)
	if player.velocity.y >= 0:
		player.velocity.x -= delta*player.friction*sign(player.velocity.x)



func _on_timeout():
	main.player_died()

