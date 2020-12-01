extends Node2D

export (int, 0, 100) var room_id
export (int, 0, 10) var height_in_screens
export (int, 0, 10) var width_in_screens
export (int, -1, 3) var bgm

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

var entrance



func _ready():
	spawn_player(entrance)
	match bgm:
		-1:
			main.music.stop()
		0:
			main.music.play_0()
		1:
			main.music.play_1()
		2:
			main.music.play_2()
		3:
			main.music.play_3()



func spawn_player(arg: int):
	var player = main.data.player_character.instance()
	var camera = player.get_node("Camera")
	camera.limit_top = 0
	camera.limit_left = 0
	camera.limit_bottom = height_in_screens*288
	camera.limit_right = width_in_screens*512
	
	if arg >= 0:
		player.position = $Entrances.get_children()[arg].position
	else:
		player.position = get_node("Checkpoint").position
		main.hp_bar.initialize(main.data.max_hp)
		main.data.hp = main.data.max_hp
	
	self.add_child(player)


