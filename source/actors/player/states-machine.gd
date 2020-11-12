extends Node2D

# The array must list them in the order they appear on the player's
# states enum, otherwise it won't work.
export (String, "Movement", "Gun") var machine_type
export (Array, Script) var states

# These must be the first states that appear on the player's enum.
var first_on_list_state: Dictionary = {
	"Movement": Player.GROUNDED_STATE,
	"Gun": Player.READY_STATE
}

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
 	state.script = states[new_state - first_on_list_state[machine_type]] # Remember their order!
	state.previous_state = old_state
	add_child(state)
	
	# In case you want to change some specific parameters in the
	# state before initializing it, make the special variable true
	# and initialize it yourself after calling change_state.
	if special:
		return state
	else:
		state.initialize()



func start_machine(starting_state: int):
	state_number = starting_state
	var state = PlayerState.new()
	state.script = states[starting_state - first_on_list_state[machine_type]]
	state.previous_state = starting_state
	add_child(state)
	state.initialize()



func get_state_node():
	return get_children()[0]


