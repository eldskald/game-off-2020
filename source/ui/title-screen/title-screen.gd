extends Node

onready var animation_player = $AnimationPlayer
onready var main = get_tree().get_nodes_in_group("main")[0]



func _ready():
	animation_player.play("start")



func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		if animation_player.is_playing():
			if animation_player.current_animation_position < 13:
				animation_player.advance(13 - animation_player.current_animation_position)
			elif animation_player.current_animation_position < 15:
				animation_player.advance(15 - animation_player.current_animation_position)
			else:
				main.start()
		else:
			main.start()



