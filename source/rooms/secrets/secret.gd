extends TileMap

export (int, 0, 100) var secret_id

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var shader: ShaderMaterial = get_material()
onready var hp: int = 5



func _ready():
	if main.data.secrets.size() > secret_id:
		if main.data.secrets[secret_id] == true:
			self.queue_free()
	else:
		print("SECRET ON ROOM " + String(get_parent().room_id) + " WITH WRONG NUMBER")



func hit(shot):
	shot.hit_a_wall()
	if shot.type in ["Heavy", "Rocket", "Explosion"]:
		destroy()
	else:
		hp -= 1
		if hp > 0:
			shader.set_shader_param("flash_white", 1.0)
			$FlashTimer.start()
		else:
			destroy()



func destroy():
	shader.set_shader_param("flash_invisible", 1.0)
	$DestroyedTimer.start()
	$SFX.play()
	main.data.secrets[secret_id] = true
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)



func _on_FlashTimer_timeout():
	shader.set_shader_param("flash_white", 0.0)

func _on_DestroyedTimer_timeout():
	self.queue_free()


