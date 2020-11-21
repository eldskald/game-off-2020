extends Sprite

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var player: Player = get_parent()
onready var animation_player: AnimationPlayer = player.get_node("AnimationPlayer")
onready var invincibility: Timer = player.get_node("InvincibilityTimer")
onready var shader: ShaderMaterial = get_material()



func _process(_delta):
	if not invincibility.is_stopped():
		shader.set_shader_param("flash_invisible", 1.0)
	else:
		shader.set_shader_param("flash_invisible", 0.0)
	
	self.scale.x = player.facing
	
	match player.get_movement_state():
		
		# Landing animation is called at airborne state script.
		Player.GROUNDED_STATE:
				if player.velocity.x == 0:
					animation_player.play("idle")
				else:
					animation_player.play("running")
		
		Player.WALL_GRABBING_STATE:
			animation_player.play("wall_grabbing")
		
		Player.STUNNED_STATE:
			animation_player.play("stunned")
		
		_:
			animation_player.play("airborne")


