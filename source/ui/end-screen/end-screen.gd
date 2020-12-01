extends Node

onready var animation_player = $AnimationPlayer
onready var main = get_tree().get_nodes_in_group("main")[0]



func _ready():
	animation_player.play("anim")



func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if animation_player.is_playing():
			if animation_player.current_animation_position < 5:
				animation_player.advance(5 - animation_player.current_animation_position)
			elif animation_player.current_animation_position < 7:
				animation_player.advance(7 - animation_player.current_animation_position)
			elif animation_player.current_animation_position < 9:
				animation_player.advance(9 - animation_player.current_animation_position)


