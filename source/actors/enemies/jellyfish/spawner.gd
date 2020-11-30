extends Node2D

export (PackedScene) var jellyfish
export (String, "Up", "Left", "Down", "Right") var moving = "Right"
export (float, 0, 500) var moving_speed
export (float, 0, 2000, 1) var despawn_distance
export (float, 0, 10) var spawn_time
export (float, 0, 10) var delay_time

onready var level = get_tree().get_nodes_in_group("level")[0]

var current_jellyfish




func _ready():
	if delay_time <= 0:
		spawn_jellyfish()
		if spawn_time > 0:
			$Timer.start(spawn_time)
	else:
		$Delay.start(delay_time)



func _physics_process(_delta):
	if current_jellyfish != null:
		if current_jellyfish.is_inside_tree():
			if (current_jellyfish.position - self.position).length() > despawn_distance:
				if current_jellyfish.get_state() == current_jellyfish.READY_STATE:
					current_jellyfish.queue_free()
					if spawn_time > 0:
						spawn_jellyfish()	
			elif current_jellyfish.get_state() == current_jellyfish.DEAD_STATE:
				if spawn_time > 0:
					spawn_jellyfish()



func spawn_jellyfish():
	current_jellyfish = jellyfish.instance()
	current_jellyfish.moving = self.moving
	current_jellyfish.moving_speed = self.moving_speed
	current_jellyfish.position = self.position
	level.call_deferred("add_child", current_jellyfish)



func _on_Timer_timeout():
	spawn_jellyfish()
	$Timer.start(spawn_time)



func _on_Delay_timeout():
	spawn_jellyfish()
	if spawn_time > 0:
		$Timer.start(spawn_time)




