extends Sprite

export (PackedScene) var light_shot_particles
export (PackedScene) var heavy_shot_particles

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var player: Player = get_parent().get_parent()
onready var muzzle: Node2D = get_node("Muzzle")
onready var charging_particles: CPUParticles2D = get_node("Muzzle/ChargingParticles")
onready var suck_particles: CPUParticles2D = get_node("Muzzle/SuckParticles")
onready var shader: ShaderMaterial = get_material()
onready var player_shader: ShaderMaterial = get_parent().get_material()
onready var invincibility: Timer = player.get_node("InvincibilityTimer")

# Sprite frames to make it easier to write and read code while
# understanding what each frame being set does.
const READY_FRAME = 0
const UNUSABLE_FRAME = 1
const FORWARD_FRAME = 2
const DOWNWARD_FRAME = 3
const BACKWARD_FRAME = 4
const UPWARD_FRAME = 5



func _process(_delta):
	if not invincibility.is_stopped():
		shader.set_shader_param("flash_invisible", 1.0)
	else:
		shader.set_shader_param("flash_invisible", 0.0)
	
	# Gun animations by code. Spawning particles happen on
	# the player script, along with spawning shots.
	match player.get_gun_state():
		Player.READY_STATE:
			frame = READY_FRAME
			muzzle.position = Vector2(9,2)
			muzzle.rotation_degrees = 0
			charging_particles.emitting = false
			suck_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.UNUSABLE_STATE:
			frame = UNUSABLE_FRAME
			muzzle.position = Vector2(-3,12)
			muzzle.rotation_degrees = 90
			charging_particles.emitting = false
			suck_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.SUCKING_STATE:
			frame = FORWARD_FRAME
			muzzle.position = Vector2(12,0)
			muzzle.rotation_degrees = 0
			charging_particles.emitting = false
			suck_particles.emitting = true
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.HOLDING_STATE:
			frame = FORWARD_FRAME
			muzzle.position = Vector2(12,0)
			muzzle.rotation_degrees = 0
			charging_particles.emitting = false
			suck_particles.emitting = true
			if player.get_gun_state_node().is_holding_shot():
				shader.set_shader_param("flash_yellow", 1.0)
				player_shader.set_shader_param("flash_yellow", 0.0)
			elif player.get_gun_state_node().is_holding_rocket():
				shader.set_shader_param("flash_yellow", 1.0)
				player_shader.set_shader_param("flash_yellow", 1.0)
		
		Player.SHOOTING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.emitting = false
			suck_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.emitting = true
			suck_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGED_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.emitting = true
			suck_particles.emitting = false
			shader.set_shader_param("flash_yellow", 1.0)
			player_shader.set_shader_param("flash_yellow", 0.0)



func multi_aim_case(aim: Vector2, facing: float):
	match aim:
		Vector2.UP:
			frame = UPWARD_FRAME
			muzzle.position = Vector2(0,-13)
			muzzle.rotation_degrees = -90
		Vector2.DOWN:
			frame = DOWNWARD_FRAME
			muzzle.position = Vector2(0,12)
			muzzle.rotation_degrees = 90
		Vector2.LEFT, Vector2.RIGHT:
			if aim.x*facing == -1:
				frame = BACKWARD_FRAME
				muzzle.position = Vector2(-12,-1)
				muzzle.rotation_degrees = 180
			else:
				frame = FORWARD_FRAME
				muzzle.position = Vector2(12,0)
				muzzle.rotation_degrees = 0



func spawn_particles(packed_particles: PackedScene):
	var level = player.get_parent()
	var particles = packed_particles.instance()
	particles.direction = player.aiming
	particles.position = level.to_local(muzzle.global_position)
	level.add_child(particles)


