tool
extends Sprite

export (String, "Two", "One", "Long Middle", "Long End") var type setget set_type



func set_type(new_type):
	type = new_type
	if Engine.editor_hint:
		match type:
			"Two":
				frame = 0
			"One":
				frame = 2
			"Long Middle":
				frame = 4
			"Long End":
				frame = 7



func _ready():
	if not Engine.editor_hint:
		$AnimationPlayer.playback_speed = 1.0/(1 + (randi()%30)/10)
		match type:
			"Two":
				$AnimationPlayer.play("sway0")
			"One":
				$AnimationPlayer.play("sway1")
			"Long Middle":
				$AnimationPlayer.play("sway2")
			"Long End":
				$AnimationPlayer.play("sway3")


