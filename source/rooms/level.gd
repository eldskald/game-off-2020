extends Node2D

export (int, 0, 10) var height_in_screens
export (int, 0, 10) var width_in_screens

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var player: Player = get_tree().get_nodes_in_group("player")[0]
onready var camera: Camera2D = player.get_node("Camera")

var entrance



func _ready():
	camera.limit_top = 0
	camera.limit_left = 0
	camera.limit_bottom = height_in_screens*288
	camera.limit_right = width_in_screens*512
	
	main.hp_bar.initialize(main.data.max_hp)



