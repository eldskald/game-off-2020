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
	var grid = $Map/Grid
	var current_room = get_tree().get_nodes_in_group("level")[0].room_id
	
	# Deal with the numbers outside the map.
	eggs_number.text = String(main.data.get_eggs_number()) + "/5"
	tanks_number.text = String(main.data.get_tanks_number()) + "/5"
	
	# Hide undiscovered secret passages in the map.
	$Map/Secret0.visible = not main.data.secrets[0]
	$Map/Secret1.visible = not main.data.secrets[1]
	$Map/Secret2.visible = not main.data.secrets[2]
	$Map/Secret3.visible = not main.data.secrets[3]
	$Map/Secret4.visible = not main.data.secrets[4]
	$Map/Secret5.visible = not main.data.secrets[5]
	$Map/Secret6.visible = not main.data.secrets[6]
	
	# Reveal visited rooms in the map.
	for room in range(main.data.visited_rooms.size()):
		if main.data.visited_rooms[room] == true:
			for cell in grid.room_cells[room]:
				cell.texture.region = grid.TRANSPARENT
				cell.get_material().set_shader_param("flash_invisible", 0.0)
	
	# Mark rooms with discovered uncaught eggs.
	if main.data.eggs[0] == false and main.data.visited_rooms[4] == true:
		grid.get_node("11").texture.region = grid.EGG
	if main.data.eggs[1] == false and main.data.visited_rooms[13] == true:
		grid.get_node("40").texture.region = grid.EGG
	if main.data.eggs[2] == false and main.data.visited_rooms[15] == true:
		grid.get_node("26").texture.region = grid.EGG
	if main.data.eggs[3] == false and main.data.visited_rooms[16] == true:
		grid.get_node("65").texture.region = grid.EGG
	if main.data.eggs[4] == false and main.data.visited_rooms[20] == true:
		grid.get_node("86").texture.region = grid.EGG
	
	# Mark rooms with discovered uncaught tanks.
	if main.data.tanks[0] == false and main.data.visited_rooms[6] == true:
		grid.get_node("14").texture.region = grid.TANK
	if main.data.tanks[1] == false and main.data.visited_rooms[9] == true:
		grid.get_node("42").texture.region = grid.TANK
	if main.data.tanks[2] == false and main.data.visited_rooms[14] == true:
		grid.get_node("37").texture.region = grid.TANK
	if main.data.tanks[3] == false and main.data.visited_rooms[19] == true:
		grid.get_node("76").texture.region = grid.TANK
	if main.data.tanks[4] == false and main.data.visited_rooms[22] == true:
		grid.get_node("39").texture.region = grid.TANK
	
	# Makes the room where the player currently is blinking.
	if current_room < 24:
		for cell in grid.room_cells[current_room]:
			cell.texture.region = grid.BLACK
			cell.get_material().set_shader_param("flash_invisible", 1.0)




