extends EnemyState

var timer



func initialize(argument):
	sprite.scale = Vector2(1, -1)
	sprite.get_material().set_shader_param("flash_invisible", 1.0)
	animation_player.play("hurt")
	enemy.get_node("Hurtbox").disabled = true
	enemy.get_node("Hitbox/Shape").disabled = true
	enemy.get_node("ShotHitbox/Shape").disabled = true
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(2.0)
	enemy.velocity = Vector2(0,-20)



func _physics_process(delta):
	enemy.vertical_movement(delta)



func _on_timeout():
	enemy.queue_free()

