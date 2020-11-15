extends Node2D

# The array must list them in the order they appear on the player's
# states enum, otherwise it won't work.
export (String, "Movement", "Gun") var machine_type
export (Array, Script) var states

var state_number




# This thing isn't supposed to be called more than once per frame,
# but horrible things can happen and it can be called multiple times
# a frame sometimes, and I think that's what causing problems. You
# can tell I'm crazy because I don't know what's going on, just take
# care the way you implement your machines.
func change_state(new_state: int, argument = null):
	call_deferred("actual_change_state", new_state, argument)

func actual_change_state(new_state: int, argument = null):
	
	# Dealing with the old state
	var old_state = state_number
	var old_state_node = get_children()[0]
	old_state_node.exit(new_state)
	old_state_node.queue_free()
	
	# Dealing with the new state
	state_number = new_state
	var state = PlayerState.new()
	state.script = states[new_state] # Remember their order!
	state.previous_state = old_state
	add_child(state)
	state.initialize(argument)



func debugging(state):
	if machine_type == "Movement":
		match state:
			Player.GROUNDED_STATE:
				print("grounded_state")
			Player.AIRBORNE_STATE:
				print("airborne_state")
			Player.JUMPING_STATE:
				print("jumping_state")
			Player.WALL_GRABBING_STATE:
				print("wall_grabbing_state")
			Player.WALL_JUMPING_STATE:
				print("wall_jumping_state")
			Player.HANGING_STATE:
				print("hanging_state")
			Player.STUNNED_STATE:
				print("stunned_state")
			Player.FLOATING_STATE:
				print("floating_state")
			Player.ROCKETING_STATE:
				print("rocketing_state")
	
	elif machine_type == "Gun":
		match state:
			Player.READY_STATE:
				print("ready_state")
			Player.CHARGING_STATE:
				print("charging_state")
			Player.CHARGED_STATE:
				print("charged_state")
			Player.SHOOTING_STATE:
				print("shooting_state")
			Player.ABSORBING_STATE:
				print("absorbing_state")
			Player.HOLDING_STATE:
				print("holding_state")
			Player.UNUSABLE_STATE:
				print("unusable_state")



func start_machine(starting_state: int, argument = null):
	state_number = starting_state
	var state = PlayerState.new()
	state.script = states[starting_state]
	state.previous_state = starting_state
	add_child(state)
	state.initialize(argument)



func get_state_node():
	return get_children()[0]


