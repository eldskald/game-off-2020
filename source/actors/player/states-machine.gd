extends Node2D

export (Array, Script) var states

onready var stack: Array = []



func change_state(new_state: int, special: bool = false):
	# Dealing with the old state
	stack.pop_front()
	var old_state = get_children()[0]
	old_state.exit()
	old_state.queue_free()
	
	# Dealing with the new state
	stack.push_front(new_state)
	var state = Node2D.new()
	state.script = states[new_state - Player.GROUNDED_STATE]
	add_child(state)
	
	# In case you want to change some specific parameters in the
	# state before initializing it, make the special variable true
	# and initialize it yourself after calling change_state.
	if special:
		return state
	else:
		state.initialize()



func clear_stack():
	while stack.size() > 1:
		stack.pop_back()


