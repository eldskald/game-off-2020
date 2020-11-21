extends EnemyState

var timer



func initialize(argument):
	timer = Timer.new()
	enemy.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(0.5)
	animation_player.play("hurt")



func _on_timeout():
	enemy.change_state(enemy.READY_STATE)


