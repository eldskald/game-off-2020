extends PlayerState

var touched_spikes = false



func initialize(argument):
	touched_spikes = argument
	player.velocity = Vector2(-player.facing, -1)*200
	player.invincibility.start()



func _physics_process(delta):
	player.vertical_movement(delta)
	if player.velocity.y >= 0:
		if not touched_spikes:
			player.change_movement_state(Player.AIRBORNE_STATE)
			player.change_gun_state(Player.READY_STATE)


