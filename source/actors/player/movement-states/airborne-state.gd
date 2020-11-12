extends PlayerState

var reached_max_fall_speed



func initialize():
	reached_max_fall_speed = false
	camera.drag_margin_top = 0.9



func _physics_process(delta):
	player.horizontal_movement(delta)
	player.vertical_movement(delta)
	if player.velocity.y >= player.falling_speed*0.9:
		reached_max_fall_speed = true
	
	# Sometimes, when we're doing a running jump at a ledge at the last
	# second before we fall, we push the button a little too late and die.
	# Coyote timer is a pity timer to allow us to make the jump even when
	# a little late. On a lot of cases, on our heads, we pushed the button
	# when we were still on the ground, but we did not jump. Just try setting
	# this timer to zero and play, try to make these jumps. Feel the difference.
	# It's mostly about feel than about making the game easier.
	if Input.is_action_just_pressed("jump") and not pity.is_stopped():
		machine.change_state(Player.JUMPING_STATE)
	
	# On the other side of the spectrum, we want to jump at the exact frame
	# we land on the ground, but we press the button a little to earlier and
	# nothing happens. Bunny timer is a pity timer to allow us to make these
	# jumps a little too early.
	elif Input.is_action_just_pressed("jump") and pity.is_stopped():
		pity.start()
	
	if player.is_on_floor():
		if Input.is_action_pressed("jump") and not pity.is_stopped():
			machine.change_state(Player.JUMPING_STATE)
		else:
			if reached_max_fall_speed:
				animation_player.play("landing")
			machine.change_state(Player.GROUNDED_STATE)



# As a last note about the pity timers, they're both about making things
# happen when our brains judged that something should have happened.
# Without them, it will feel like the game is eating away some jump inputs,
# leaving a sour taste in the player's mouth and making the controls feel
# unresponsive.


