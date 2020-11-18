extends KinematicBody2D

export (float, 0, 1000) var speed
export (String, "Light", "Heavy") var type

var direction: Vector2 = Vector2.ZERO
var suckable: bool = true
var caught: bool = false
var player_muzzle = null



func _physics_process(delta):
	if caught:
		var distance = player_muzzle.global_position - self.global_position
		if distance.length_squared() <= 36:
			var player = player_muzzle.get_parent().get_parent().get_parent()
			player.change_gun_state(Player.HOLDING_STATE, self)
			destroy()
		direction = distance.normalized()
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
	area.hit(self)



func hit(source):
	match type:
		"Light":
			destroy()
		"Heavy":
			if source.type != "Light":
				destroy()



func hit_a_wall():
	destroy()



func grabbed(player: Player):
	$Yellow.emitting = false
	$White.emitting = false
	$Grabbed.emitting = true
	$Hitbox/CollisionShape2D.disabled = true
	player_muzzle = player.get_node("Sprite/GunSprite/Muzzle")
	caught = true
	speed = 300

func can_be_grabbed():
	return suckable



func _on_screen_exited():
	self.queue_free()







