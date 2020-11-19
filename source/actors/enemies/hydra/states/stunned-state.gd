extends EnemyState

var timer
onready var is_white: bool = true



func initialize(argument):
	timer = Timer.new()
	enemy.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(0.2)
	animation_player.play("stunned")
	sprite.get_material().set_shader_param("flash_white", 1.0)



func _on_timeout():
	if is_white:
		sprite.get_material().set_shader_param("flash_white", 0.0)
		is_white = false
		timer.start(0.3)
	else:
		enemy.change_state(enemy.READY_STATE)


