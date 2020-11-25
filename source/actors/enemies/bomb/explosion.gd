extends Node2D

var type: String = "Explosion"



func _on_body_entered(body):
	body.hit(self)

func _on_area_entered(area):
	if area.get_collision_layer_bit(5) == true: # Shots layer
		area.get_parent().hit(self)



func hit(source):
	pass # Nothing happens if an explosion is shot.

func destroy():
	pass # Can't be stopped.



func can_be_grabbed():
	return false



func _ready():
	$AnimationPlayer.play("explode")


