extends PlayerState

onready var suck_area: Area2D = muzzle.get_node("SuckArea")
onready var held_area: Area2D = muzzle.get_node("HeldArea")



#func initialize():
#	held_area.connect("body_entered", self, "_on_body_entered")

#func _on_body_entered(body):
#	var state = machine.change_state(Player.HOLDING_STATE, true)
#	state.holding_node = held_area.get_overlapping_bodies()[0]
#	state.initialize()



func _physics_process(_delta):
	player.aiming = Vector2(player.facing, 0)
	
	if held_area.get_overlapping_bodies().size() > 0:
		var state = machine.change_state(Player.HOLDING_STATE, true)
		state.holding_node = held_area.get_overlapping_bodies()[0]
		state.initialize()
	else:
		
		# Leaving this state by either shooting or letting go of the button.
		if not Input.is_action_pressed("absorb"):
			machine.change_state(Player.READY_STATE)
		
		# Outside an elif statement in case the player shoots without letting
		# go of the absorb button.
		if get_just_pressed_shoot_dir() != Vector2.ZERO:
			player.aiming = get_pressed_shoot_dir()
			machine.change_state(Player.CHARGING_STATE)


