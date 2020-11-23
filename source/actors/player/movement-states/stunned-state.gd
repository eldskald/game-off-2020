extends PlayerState

var timer



func initialize(argument):
	player.velocity = Vector2(-player.facing, -1)*200
	player.invincibility.start()



func _physics_process(delta):
	player.vertical_movement(delta)
	if player.velocity.y >= 0:
		player.change_movement_state(Player.AIRBORNE_STATE)


