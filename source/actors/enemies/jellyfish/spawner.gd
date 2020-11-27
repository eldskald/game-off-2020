extends Node2D

export (PackedScene) var jellyfish
export (String, "Up", "Left", "Down", "Right") var moving = "Right"
export (float, 0, 500) var moving_speed
export (float, 0, 2000, 1) var despawn_distance

onready var level = get_tree().get_nodes_in_group("level")[0]

var current_jellyfish




func _ready():
	spawn_jellyfish()

func _physics_process(_delta):
	if current_jellyfish != null:
		if current_jellyfish.is_inside_tree():
			if (current_jellyfish.position - self.position).length() > despawn_distance:
				if current_jellyfish.get_state() == current_jellyfish.READY_STATE:
					current_jellyfish.queue_free()
					spawn_jellyfish()
			elif current_jellyfish.get_state() == current_jellyfish.DEAD_STATE:
				spawn_jellyfish()



func spawn_jellyfish():
	current_jellyfish = jellyfish.instance()
	current_jellyfish.moving = self.moving
	current_jellyfish.moving_speed = self.moving_speed
	current_jellyfish.position = self.position
	level.call_deferred("add_child", current_jellyfish)





