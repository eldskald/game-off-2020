extends PlayerState

var timer



func initialize(argument):
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "over")
	timer.start(argument)

func over():
	player.change_gun_state(Player.READY_STATE)


