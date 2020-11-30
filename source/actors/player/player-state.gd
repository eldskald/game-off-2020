extends Node
class_name PlayerState

var previous_state

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var machine = get_parent()

onready var player: Player = get_parent().get_parent()
onready var animation_player: AnimationPlayer = player.get_node("AnimationPlayer")
onready var sprite: Sprite = player.get_node("Sprite")
onready var gun: Sprite = sprite.get_node("GunSprite")
onready var muzzle: Node2D = gun.get_node("Muzzle")
onready var camera: Camera2D = player.get_node("Camera")

onready var pity: Timer = player.get_node("PityTimer")
onready var charge: Timer = player.get_node("ChargeTimer")
onready var cooldown: Timer = player.get_node("ShotCooldown")



# Override these functions. They are both called during the chage_state
# method on the states machine, read it for more info. The idea is that
# each state will have their own use for them, hence why overriding these
# empty ones defined for hierarchy purposes.

func initialize(argument):
	pass

func exit(next_state: int):
	pass



# Deals with directional shoot inputs in a similar manner the main node
# handles directional inputs. The only difference is these inputs can't
# be diagonal, so we'll turn diagonals into vertical directions to
# prioritize shooting charged and rocket shots down.
var old_input: Vector2 = Vector2.ZERO
var just_pressed: Vector2 = Vector2.ZERO
var just_released: Vector2 = Vector2.ZERO

func _physics_process(_delta):
	if old_input != get_pressed_aim_dir():
		just_pressed = get_pressed_aim_dir()
		just_released = old_input
	else:
		just_pressed = Vector2.ZERO
		just_released = Vector2.ZERO
	old_input = get_pressed_aim_dir()

func get_pressed_aim_dir() -> Vector2:
	if main.is_using_controller():
		var right_stick = Vector2(Input.get_joy_axis(0, JOY_AXIS_2),
								  Input.get_joy_axis(0, JOY_AXIS_3))
		
		if right_stick.length_squared() > 0.16:
			return main.discretize_angle(right_stick.angle())
		else:
			return Vector2( Input.get_action_strength("aim_right")
							-Input.get_action_strength("aim_left"),
							Input.get_action_strength("aim_down")
							-Input.get_action_strength("aim_up"))
	else:
		return main.discretize_angle(player.get_local_mouse_position().angle())

func get_just_pressed_aim_dir() -> Vector2:
	return just_pressed

func get_just_released_aim_dir() -> Vector2:
	return just_released



# This is to animate the holding state. Overriden on holding state script.
func is_holding_shot_or_rocket():
	return false

func is_holding_rocket():
	return false

func is_holding_mega_rocket():
	return false




