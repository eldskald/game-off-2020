extends Control

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

onready var eggs_number = $Numbers/VBox/EggsNumber
onready var tanks_number = $Numbers/VBox/TanksNumber



func _input(event):
	if main.can_pause:
		if event.is_action_pressed("pause"):
			get_tree().paused = not get_tree().paused
			self.visible = not self.visible
			update_pause_screen()
		elif event.is_action_pressed("reload"):
			get_tree().paused = false
			self.visible = false
			main.reload_room()



func update_pause_screen():
	eggs_number.text = String(main.data.get_eggs_number()) + "/5"
	tanks_number.text = String(main.data.get_tanks_number()) + "/5"



