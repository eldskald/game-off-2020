tool
extends Sprite

export (String, "Two", "One", "Long Middle", "Long End") var type setget set_type



func set_type(new_type):
	if Engine.editor_hint:
		type = new_type
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
		var speed_mod = 1 + (randi()%30)/10
		match type:
			"Two":
				$AnimationPlayer.play("sway0", -1, 1.0/speed_mod)
			"One":
				$AnimationPlayer.play("sway1", -1, 1.0/speed_mod)
			"Long, Middle":
				$AnimationPlayer.play("sway2", -1, 1.0/speed_mod)
			"Long, End":
				$AnimationPlayer.play("sway3", -1, 1.0/speed_mod)


