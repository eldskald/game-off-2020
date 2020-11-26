extends Node

onready var main = get_parent()

export (PackedScene) var player_character
export (PackedScene) var health_pickup
export (Array, PackedScene) var rooms

var hp: int = 5
var max_hp: int = 5

var current_checkpoint: int = 0
var secrets: Array = [false, false, false, false, false, false, false, false, false, false]
var eggs: Array = [false, false, false, false, false, false, false, false, false, false]
var tanks: Array = [false, false, false, false, false]


# In case I do add a save file, this will be used to load up
# the current data instead of initializing these values.
#func _ready():
#	hp = 5
#	max_hp = 5
#	current_checkpoint = 0
#	secrets = [false, false, false, false, false, false]
#	eggs = [false, false, false, false, false, false, false, false, false, false]
#	tanks = [false, false, false, false, false]



func is_player_hurt() -> bool:
	return hp < max_hp

func drop_health_pickup(location: Vector2):
	if is_player_hurt():
		var level = get_tree().get_nodes_in_group("level")[0]
		var chance = randi()%2
		if chance == 1:
			var drop = health_pickup.instance()
			drop.position = location
			level.add_child(drop)

func heal_to_full():
	main.hp_bar.move_bar(hp, max_hp)
	hp = max_hp

func heal_one_notch():
	main.hp_bar.move_bar(hp, clamp(hp + 1, 0, max_hp))
	hp = clamp(hp + 1, 0, max_hp)

func increase_max_hp():
	max_hp += 1
	main.hp_bar.activate_tank(max_hp)
	heal_to_full()



