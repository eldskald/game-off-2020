extends Node2D

# Works in just like the player states machine, with a couple of less
# functionalities.
export (Array, Script) var states

var state_number
var changing_state = false



func change_state(new_state: int, argument = null):
	if not changing_state:
		call_deferred("actual_change_state", new_state, argument)
		changing_state = true

func actual_change_state(new_state: int, argument = null):
	changing_state = false
	
	var old_state = state_number
	var old_state_node = get_children()[0]
	old_state_node.exit(new_state)
	old_state_node.queue_free()
	
	state_number = new_state
	var state = EnemyState.new()
	state.script = states[new_state]
	state.previous_state = old_state
	add_child(state)
	state.initialize(argument)



func start_machine(starting_state: int, argument = null):
	state_number = starting_state
	var state = EnemyState.new()
	state.script = states[starting_state]
	state.previous_state = starting_state
	add_child(state)
	state.initialize(argument)



func get_state_node():
	return get_children()[0]


