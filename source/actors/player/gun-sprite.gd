extends Sprite

onready var main: Main = get_tree().get_nodes_in_group("main")[0]
onready var player: Player = get_parent().get_parent()
onready var muzzle: Node2D = get_node("Muzzle")
onready var charging_particles: CPUParticles2D = get_node("Muzzle/ChargingParticles")
onready var charge_particles_timer: Timer = get_node("Muzzle/ChargingParticles/Timer")
onready var absorb_particles: CPUParticles2D = get_node("Muzzle/AbsorbParticles")
onready var muzzle_flash: Sprite = get_node("Muzzle/MuzzleFlash")
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
			charging_particles.visible = false
			charge_particles_timer.stop()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.UNUSABLE_STATE:
			frame = UNUSABLE_FRAME
			muzzle.position = Vector2(-3,12)
			muzzle.rotation_degrees = 90
			charging_particles.emitting = false
			charging_particles.visible = false
			charge_particles_timer.stop()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.ABSORBING_STATE:
			frame = FORWARD_FRAME
			muzzle.position = Vector2(12,0)
			muzzle.rotation_degrees = 0
			charging_particles.emitting = false
			charging_particles.visible = false
			charge_particles_timer.stop()
			absorb_particles.emitting = true
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.HOLDING_STATE:
			frame = FORWARD_FRAME
			muzzle.position = Vector2(12,0)
			muzzle.rotation_degrees = 0
			charging_particles.emitting = false
			charging_particles.visible = false
			charge_particles_timer.stop()
			absorb_particles.emitting = true
			if player.get_gun_state_node().is_holding_shot():
				shader.set_shader_param("flash_yellow", 1.0)
				player_shader.set_shader_param("flash_yellow", 1.0)
			elif player.get_gun_state_node().is_holding_rocket():
				shader.set_shader_param("flash_yellow", 1.0)
				player_shader.set_shader_param("flash_yellow", 1.0)
		
		Player.SHOOTING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.emitting = false
			charging_particles.visible = false
			charge_particles_timer.stop()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGING_STATE:
			multi_aim_case(player.aiming, player.facing)
			absorb_particles.emitting = false
			charging_particles.visible = true
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGED_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.emitting = true
			charging_particles.visible = true
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 1.0)
			player_shader.set_shader_param("flash_yellow", 1.0)



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



func spawn_muzzle_flash():
	muzzle_flash.frame = randi()%3
	muzzle_flash.visible = true
	$Muzzle/MuzzleFlash/Timer.start()



func _on_muzzle_flash_timeout():
	muzzle_flash.visible = false



func _charge_particles_timeout():
	charging_particles.emitting = true

