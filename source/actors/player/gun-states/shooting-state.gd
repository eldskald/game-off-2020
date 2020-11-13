extends PlayerState

var timer
var duration: float = 1.0



func initialize():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "over")
	timer.start(duration)



func over():
	machine.change_state(Player.READY_STATE)


