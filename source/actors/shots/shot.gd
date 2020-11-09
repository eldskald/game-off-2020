extends KinematicBody2D

export (float, 0, 1000) var speed
export (float, 0, 1000) var range_ # I can't name it just range...
export (String, "Light", "Heavy") var type

var direction: Vector2 = Vector2.ZERO
var suckable: bool = false
var destroyed: bool = false



func _ready():
	$DurationTimer.start(range_/speed)

func _physics_process(delta):
	move_and_slide(direction*speed)



func destroy():
	if not destroyed:
		destroyed = true
		speed = 0.0
		$Yellow.emitting = false
		$White.emitting = false
		$Hitbox.monitoring = false
		$Hitbox.monitorable = false
		$DurationTimer.start(1.0)
	else:
		queue_free()



func _on_body_entered(body):
	body.take_damage(type)



func _on_area_entered(area):
	if area.is_on_group("shot"):
		match type:
			"Light":
				destroy()
			"Heavy":
				if area.type == "Heavy":
					destroy()


