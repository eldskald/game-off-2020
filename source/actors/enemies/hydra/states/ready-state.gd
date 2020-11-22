extends EnemyState

var timer
var started = false

onready var visibility = enemy.get_node("VisibilityNotifier2D")



func initialize(argument):
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	timer.one_shot = true
	timer.start(0.1)
	
	visibility.connect("viewport_entered", self, "_on_entered_screen")
	visibility.connect("viewport_exited", self, "_on_exited_screen")
	
	if animation_player.current_animation != "ready":
		animation_player.play("ready", -1, 1 + (randi()%10)/10)
		animation_player.advance((randi()%30)/10)



func _physics_process(delta):
	if enemy.is_being_sucked():
		enemy.vacuum_suck(delta)
	else:
		enemy.horizontal_movement(delta)
		enemy.vertical_movement(delta)



func _on_timeout():
	if started:
		enemy.change_state(enemy.CHARGING_STATE)
	else:
		started = true
		if visibility.is_on_screen():
			timer.start(1 + (randi()%10)/10)

func _on_entered_screen(viewport):
	timer.start(1 + (randi()%10)/10)

func _on_exited_screen(viewport):
	timer.stop()


