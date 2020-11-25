extends Node2D

var type: String = "Rocket"

onready var raycast = $WallFinder
onready var sprite = $Source/Laser
onready var hitbox = $Hitbox/Shape



func _on_body_entered(body):
	body.hit(self)

func _on_area_entered(area):
	if area.get_collision_layer_bit(5) == true: # Shots layer
		area.get_parent().hit(self)

func hit(source):
	pass # Nothing happens if an explosion is shot.

func destroy():
	pass # Can't be stopped.



func activate():
	$AnimationPlayer.play("activate")
	raycast.enabled = true
	hitbox.disabled = false

func deactivate():
	$AnimationPlayer.play("deactivate")
	raycast.enabled = false
	hitbox.disabled = true

func deactivate_instantly():
	$AnimationPlayer.stop()
	$Source.visible = false
	raycast.enabled = false
	hitbox.disabled = true



func _physics_process(_delta):
	if raycast.enabled:
		var length = 600
		if raycast.is_colliding():
			length = (raycast.get_collision_point() - self.global_position).length() + 32
		sprite.scale.y = -length
		hitbox.polygon[2].y = length
		hitbox.polygon[3].y = length
	




