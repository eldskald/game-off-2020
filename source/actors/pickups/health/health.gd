extends KinematicBody2D

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

onready var friction: float = 100.0
onready var suck_acceleration: float = 500.0
onready var hitbox: Area2D = $Hitbox
onready var velocity: Vector2 = Vector2.ZERO
onready var shader: ShaderMaterial = $Sprite.get_material()



func apply_friction(delta):
	var new_vel = clamp(velocity.length() - friction*delta, 0, 1000)
	velocity = velocity.normalized()*new_vel

func vacuum_suck(delta):
	var muzzle = hitbox.get_overlapping_areas()[0].get_parent()
	var distance = muzzle.global_position - self.global_position
	velocity += distance.normalized()*suck_acceleration*delta
	var dif_angle = distance.angle() - velocity.angle()
	velocity = velocity.rotated(min(2*PI*delta, abs(dif_angle))*sign(dif_angle))

func is_being_sucked() -> bool:
	return hitbox.get_overlapping_areas().size() > 0



func _on_body_entered(body):
	if body.get_collision_layer_bit(0) == true: # Player's layer
		main.hp_bar.move_bar(main.data.hp, main.data.hp + 1)
		main.data.hp = clamp(main.data.hp + 1, 0, main.data.max_hp)
		self.queue_free()

func grabbed(body):
	_on_body_entered(body)



func _on_timeout():
	if shader.get_shader_param("flash_invisible") == 0:
		shader.set_shader_param("flash_invisible", 1.0)
		$Timer.start(3.0)
	else:
		self.queue_free()



func _physics_process(delta):
	if is_being_sucked():
		vacuum_suck(delta)
	else:
		apply_friction(delta)
	velocity = move_and_slide(velocity, Vector2.UP)





