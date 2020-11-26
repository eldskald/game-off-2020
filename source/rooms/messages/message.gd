extends Label

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

export (String, MULTILINE) var keyboard_text
export (String, MULTILINE) var controller_text



func _ready():
	main.connect("input_device_changed", self, "update_text")
	update_text()



func update_text():
	if main.is_using_keyboard():
		self.text = keyboard_text
	else:
		self.text = controller_text


