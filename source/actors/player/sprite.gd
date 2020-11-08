extends Sprite

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var player: Player = get_parent()
onready var animation_player: AnimationPlayer = player.get_node("AnimationPlayer")



func _physics_process(delta):
	self.scale.x = player.facing
	
	match player.get_movement_state():
		
		# Sorry for the spaghetti.
		Player.GROUNDED_STATE:
			if animation_player.current_animation != "landing":
				if player.velocity.x == 0 and animation_player.current_animation != "braking":
					animation_player.play("idle")
				else:
					if main.get_dir_input().x == 0:
						animation_player.play("braking")
					else:
						animation_player.play("running")
		
		Player.WALL_GRABBING_STATE:
			animation_player.play("wall_grabbing")
		
		Player.STUNNED_STATE:
			animation_player.play("stunned")
		
		_:
			animation_player.play("airborne")


