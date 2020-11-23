extends Node

var hp: int
var max_hp: int

var secrets: Array
var eggs: Array
var tanks: Array


# In case I do add a save file, this will be used to load up
# the current data instead of initializing these values.
func _ready():
	hp = 5
	max_hp = 5
	secrets = [false, false, false, false, false, false]
	eggs = [false, false, false, false, false, false, false, false, false, false]
	tanks = [false, false, false, false, false]

