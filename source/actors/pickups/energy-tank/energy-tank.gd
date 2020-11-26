extends Node2D

export (int, 0, 100) var tank_id

onready var main: Main = get_tree().get_nodes_in_group("main")[0]



func _ready():
	if main.data.tanks.size() > tank_id:
		if main.data.tanks[tank_id] == true:
			self.queue_free()
		else:
			$AnimationPlayer.play("standing")
	else:
		print("TANK ON ROOM " + String(get_parent().room_id) + " WITH WRONG NUMBER")



func _on_Hitbox_body_entered(body):
	main.data.tanks[tank_id] = true
	main.data.increase_max_hp()
	self.queue_free()

func grabbed(body):
	_on_Hitbox_body_entered(body)


