extends KinematicBody2D

export (float, 0, 1000) var speed
export (String, "Light", "Heavy") var type

var direction: Vector2 = Vector2.ZERO
var suckable: bool = false



func _physics_process(delta):
	move_and_slide(direction*speed)



func destroy():
	speed = 0.0
	$Yellow.emitting = false
	$White.emitting = false
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "_on_screen_exited")
	timer.start(1.0)



func _on_body_entered(body):
	body.hit(self)



func _on_area_entered(area):
	if area.is_in_group("shot"):
		match type:
			"Light":
				destroy()
			"Heavy":
				if area.type == "Heavy":
					destroy()



func _on_screen_exited():
	self.queue_free()
