extends Node

onready var main = get_parent()

export (PackedScene) var health_pickup

var hp: int
var max_hp: int

var current_checkpoint: int
var secrets: Array
var eggs: Array
var tanks: Array


# In case I do add a save file, this will be used to load up
# the current data instead of initializing these values.
func _ready():
	hp = 5
	max_hp = 5
	current_checkpoint = 0
	secrets = [false, false, false, false, false, false]
	eggs = [false, false, false, false, false, false, false, false, false, false]
	tanks = [false, false, false, false, false]



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




