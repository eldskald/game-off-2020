extends Node2D
class_name Main

export (PackedScene) var title_screen



func _ready():
	OS.window_size = Vector2(1024,576)
	add_child(title_screen.instance())



func start():
	pass



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
	return Vector2( Input.get_action_strength("right") - Input.get_action_strength("left"), 
					Input.get_action_strength("down") - Input.get_action_strength("up"))

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
	
	if event is InputEventKey:
		new_input_device = "Keyboard"
		if new_input_device != last_input_device:
			emit_signal("input_device_changed")
		last_input_device = new_input_device
	
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		new_input_device = "Controller"
		if new_input_device != last_input_device:
			emit_signal("input_device_changed")
		last_input_device = new_input_device

func is_using_keyboard() -> bool:
	return last_input_device == "Keyboard"

func is_using_controller() -> bool:
	return last_input_device == "Controller"
###########################################################################################



