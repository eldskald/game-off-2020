extends PlayerState

var timer



func initialize(argument):
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.start(argument)



func _on_timeout():
	player.change_gun_state(Player.READY_STATE)


