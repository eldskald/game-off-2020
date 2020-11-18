extends Node
class_name EnemyState

var previous_state

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var machine = get_parent()
onready var enemy = machine.get_parent()
onready var sprite = enemy.get_node("Sprite")



# Same as player state. Override these functions too.

func initialize(argument):
	pass

func exit(next_state: int):
	pass

