extends Node2D

# The array must list them in the order they appear on the player's
# states enum, otherwise it won't work.
export (String, "Movement", "Gun") var machine_type
export (Array, Script) var states

# These must be the first states that appear on the player's enum.
#var first_on_list_state: Dictionary = {
#	"Movement": Player.GROUNDED_STATE,
#	"Gun": Player.READY_STATE
#}

var state_number



func change_state(new_state: int, special: bool = false):
	
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
	
	# In case you want to change some specific parameters in the
	# state before initializing it, make the special variable true
	# and initialize it yourself after calling change_state.
	if special:
		return state
	else:
		state.initialize()



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



func start_machine(starting_state: int):
	state_number = starting_state
	var state = PlayerState.new()
	state.script = states[starting_state]
	state.previous_state = starting_state
	add_child(state)
	state.initialize()



func get_state_node():
	return get_children()[0]


