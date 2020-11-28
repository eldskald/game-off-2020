extends Node
class_name Main

export (PackedScene) var title_screen

onready var hp_bar = $UI/HealthBar
onready var data = $Data
onready var scene = $Scene
onready var transition = $UI/Transition

var can_pause = false



func _ready():
	OS.window_size = Vector2(1024,576)
	OS.center_window()
	transition.get_node("Timer").connect("timeout", self, "_on_transition_timer_timeout")
	transition.get_node("AnimationPlayer").connect("animation_finished",
												   self, "_on_transition_finished")
	scene.add_child(title_screen.instance())

func _process(_delta):
	if is_using_keyboard():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



func start():
	can_pause = true
	change_room(data.rooms[0], -1)



func player_died():
	change_room(data.rooms[data.current_checkpoint], -1)



### CHANGING ROOMS ########################################################################
var next_entrance: int
var next_room: PackedScene

func change_room(room: PackedScene, entrance: int):
	if not transition.animation_player.is_playing() and transition.timer.is_stopped():
		next_entrance = entrance
		next_room = room
		transition.close_screen()

func _on_transition_finished(anim_name: String):
	if anim_name == "out":
		if scene.get_children().size() > 0:
			scene.get_children()[0].queue_free()
		transition.timer.start()

func _on_transition_timer_timeout():
	var room = next_room.instance()
	room.entrance = next_entrance
	scene.call_deferred("add_child", room)
	transition.open_screen()

# This function calls the same last instance of change_room's last call.
func reload_room():
	change_room(next_room, next_entrance)
###########################################################################################



### Dealing with directional inputs in a more applicable way ##############################
var old_input: Vector2 = Vector2.ZERO
var just_pressed: Vector2 = Vector2.ZERO
var just_released: Vector2 = Vector2.ZERO

func _physics_process(_delta):
	if old_input != get_dir_input():
		just_pressed = get_dir_input()
		just_released = old_input
	else:
		just_pressed = Vector2.ZERO
		just_released = Vector2.ZERO
	old_input = get_dir_input()

func get_dir_input() -> Vector2:
	var stick = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
	if stick.length_squared() > 0.16:
		return discretize_angle(stick.angle())
	else:
		return Vector2( Input.get_action_strength("right") - Input.get_action_strength("left"), 
						Input.get_action_strength("down") - Input.get_action_strength("up"))

func discretize_angle(angle: float):
	if angle > -7*PI/8 and angle <= -5*PI/8:
		return Vector2(-1,-1)
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		return Vector2(0,-1)
	elif angle > -3*PI/8 and angle <= -PI/8:
		return Vector2(1,-1)
	elif angle > -PI/8 and angle <= PI/8:
		return Vector2(1,0)
	elif angle > PI/8 and angle <= 3*PI/8:
		return Vector2(1,1)
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		return Vector2(0,1)
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		return Vector2(-1,1)
	else:
		return Vector2(-1,0)

func get_just_pressed_dir_input() -> Vector2:
	return just_pressed

func get_just_released_dir_input() -> Vector2:
	return just_released
###########################################################################################



### Detects whether the player is using a keyboard or a controller ########################
var last_input_device: String = "Keyboard"
signal input_device_changed

func _input(event):
	var new_input_device
	
	if event is InputEventKey or event is InputEventMouse:
		new_input_device = "Keyboard"
		if new_input_device != last_input_device:
			last_input_device = new_input_device
			emit_signal("input_device_changed")
		else:
			last_input_device = new_input_device
	
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		new_input_device = "Controller"
		if new_input_device != last_input_device:
			last_input_device = new_input_device
			emit_signal("input_device_changed")
		else:
			last_input_device = new_input_device

func is_using_keyboard() -> bool:
	return last_input_device == "Keyboard"

func is_using_controller() -> bool:
	return last_input_device == "Controller"
###########################################################################################





