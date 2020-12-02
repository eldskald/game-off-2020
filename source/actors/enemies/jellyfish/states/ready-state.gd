extends EnemyState

onready var visibility_notifier: VisibilityNotifier2D = enemy.get_node("VisibilityNotifier2D")
onready var visibility_timer: Timer = enemy.get_node("VisibilityNotifier2D/Timer")


func initialize(argument):
	animation_player.play("floating")
	
	# To make them dance in synchrony!
	if enemy.starting_animation_frame < 0:
		animation_player.advance(float(randi()%40)/10)
	else:
		var converted = int(enemy.starting_animation_frame*10.0)
		animation_player.advance(float(converted%40)/10.0)



func _physics_process(delta):
	if enemy.is_being_sucked():
		enemy.vacuum_suck(delta)
	else:
		
		# Bobbing up and down animation is calculated to take 1 second to
		# go up, then 3 seconds to go down. Velocity goes up is a function
		# called by the animation player itself.
		if enemy.moving == "Static":
			if enemy.velocity.y >= 0:
				enemy.acceleration = Vector2(0, 32/9)
		
		# Despawning it after it went offscreen after sometime if it's not static.
		elif not visibility_notifier.is_on_screen() and visibility_timer.is_stopped():
			enemy.queue_free()


