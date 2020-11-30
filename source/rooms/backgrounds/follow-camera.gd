extends Node2D

func _process(delta):
	if get_tree().get_nodes_in_group("player").size() > 0:
		var camera = get_tree().get_nodes_in_group("player")[0].get_node("Camera")
		self.position = camera.get_camera_screen_center()
