extends PlayerState

onready var suck_area: Area2D = muzzle.get_node("SuckArea")
onready var held_area: Area2D = muzzle.get_node("HeldArea")



func _physics_process(_delta):
	if get_pressed_aim_dir() == Vector2.ZERO:
		player.aiming = Vector2(player.facing, 0)
	else:
		player.aiming = get_pressed_aim_dir()
	
	if held_area.get_overlapping_bodies().size() > 0:
		var state = machine.change_state(Player.HOLDING_STATE, true)
		state.holding_node = held_area.get_overlapping_bodies()[0]
		state.initialize()
	else:
		if not Input.is_action_pressed("absorb"):
			machine.change_state(Player.READY_STATE)
		
		if Input.is_action_just_pressed("shoot"):
			machine.change_state(Player.CHARGING_STATE)


