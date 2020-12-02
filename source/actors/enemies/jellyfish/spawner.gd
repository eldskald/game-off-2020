extends Node2D

export (PackedScene) var jellyfish
export (String, "Up", "Left", "Down", "Right") var moving = "Right"
export (float, 0, 500) var moving_speed
export (float, 0, 20) var spawn_time
export (float, 0, 20) var delay_time

onready var level = get_tree().get_nodes_in_group("level")[0]



func _ready():
	if delay_time <= 0:
		spawn_jellyfish()
		if spawn_time > 0:
			$Timer.start(spawn_time)
	else:
		$Delay.start(delay_time)



func spawn_jellyfish():
	var node = jellyfish.instance()
	node.moving = self.moving
	node.moving_speed = self.moving_speed
	node.position = self.position
	level.call_deferred("add_child", node)



func _on_Timer_timeout():
	spawn_jellyfish()
	$Timer.start(spawn_time)



func _on_Delay_timeout():
	spawn_jellyfish()
	if spawn_time > 0:
		$Timer.start(spawn_time)




