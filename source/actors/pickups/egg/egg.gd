extends Node2D

export (int, 0, 100) var egg_id

onready var main: Main = get_tree().get_nodes_in_group("main")[0]



func _ready():
	if main.data.eggs.size() > egg_id:
		if main.data.eggs[egg_id] == true:
			self.queue_free()
		else:
			$AnimationPlayer.play("standing")
	else:
		print("EGG ON ROOM " + String(get_parent().room_id) + " WITH WRONG NUMBER")



func _on_Hitbox_body_entered(body):
	body.sfx.pickup()
	main.data.eggs[egg_id] = true
	self.queue_free()

func grabbed(body):
	_on_Hitbox_body_entered(body)


