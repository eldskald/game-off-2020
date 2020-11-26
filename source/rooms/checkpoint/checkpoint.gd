extends StaticBody2D

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var level = get_parent()
onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var active = main.data.current_checkpoint == level.room_id



func _ready():
	match active:
		true:
			animation_player.play("active")
		false:
			animation_player.play("inactive")



func _on_Detector_body_entered(body):
	if body.is_in_group("player") and $Ready.is_stopped():
		main.data.heal_to_full()
		animation_player.play("activating")



func _on_animation_finished(anim_name):
	if anim_name == "activating":
		active = true
		main.data.current_checkpoint = level.room_id
		animation_player.play("active")


