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



