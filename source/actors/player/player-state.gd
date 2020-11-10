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

onready var coyote: Timer = player.get_node("CoyoteJumpTimer")
onready var bunny: Timer = player.get_node("BunnyJumpTimer")
onready var charge: Timer = player.get_node("ChargeTimer")



# Override these functions. They are both called during the chage_state
# method on the states machine, read it for more info. The idea is that
# each state will have their own use for them, hence why overriding these
# empty ones defined for hierarchy purposes.

func initialize():
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
	if old_input != get_shoot_dir():
		just_pressed = get_shoot_dir()
		just_released = old_input
	else:
		just_pressed = Vector2.ZERO
		just_released = Vector2.ZERO
	old_input = get_shoot_dir()

func get_shoot_dir() -> Vector2:
	return Vector2( Input.get_action_strength("shoot_right")
					- Input.get_action_strength("shoot_left"), 
					Input.get_action_strength("shoot_down")
					- Input.get_action_strength("shoot_up"))

func get_pressed_shoot_dir() -> Vector2:
	var dir = get_shoot_dir()
	if dir in [Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)]:
		return Vector2(0, dir.y)
	else:
		return dir

func get_just_pressed_shoot_dir() -> Vector2:
	if just_pressed in [Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)]:
		return Vector2(0, just_pressed.y)
	else:
		return just_pressed

func get_just_released_shoot_dir() -> Vector2:
	if just_released in [Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)]:
		return Vector2(0, just_released.y)
	else:
		return just_released


