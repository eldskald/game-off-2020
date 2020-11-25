extends Area2D

export (int, 0, 100) var next_room
export (int, 0, 10) var next_entrance

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

func _on_body_entered(body):
	if body.is_in_group("player"):
		main.change_room(main.data.rooms[next_room], next_entrance)



