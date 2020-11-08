extends Node2D

export (String, "Movement", "Gun") var machine_type
export (Array, Script) var states

# These must be the first states that appear on the player's enum.
var first_on_list_state: Dictionary = {
	"Movement": Player.GROUNDED_STATE,
	"Gun": Player.READY_STATE
}

# You must put them in the order they appear on the player's enum,
# otherwise it won't work.
onready var stack: Array = []



func change_state(new_state: int, special: bool = false):
	# Dealing with the old state
	stack.pop_front()
	var old_state = get_children()[0]
	old_state.exit(new_state)
	old_state.queue_free()
	
	# Dealing with the new state
	stack.push_front(new_state)
	var state = Node.new()
	state.script = states[new_state - first_on_list_state[machine_type]] # Remember their order!
	add_child(state)
	
	# In case you want to change some specific parameters in the
	# state before initializing it, make the special variable true
	# and initialize it yourself after calling change_state.
	if special:
		return state
	else:
		state.initialize()



func start_machine(starting_state: int):
	stack.push_front(starting_state)
	var state = Node.new()
	state.script = states[starting_state - first_on_list_state[machine_type]]
	add_child(state)
	state.initialize()



func get_previous_state():
	if stack.size() > 1:
		return stack[1]
	else:
		return null



func clear_stack():
	while stack.size() > 1:
		stack.pop_back()


