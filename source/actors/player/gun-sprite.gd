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



func _process(_delta):
	if not invincibility.is_stopped():
		shader.set_shader_param("flash_invisible", 1.0)
	else:
		shader.set_shader_param("flash_invisible", 0.0)
	
	# Gun animations by code. Spawning particles happen on
	# the player script, along with spawning shots.
	match player.get_gun_state():
		Player.READY_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.restart()
			charging_particles.emitting = false
			charge_particles_timer.stop()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.UNUSABLE_STATE:
			frame = UNUSABLE_FRAME
			muzzle.position = Vector2(-3,12)
			muzzle.rotation_degrees = 90
			charging_particles.restart()
			charging_particles.emitting = false
			charge_particles_timer.stop()
			absorb_particles.restart()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.ABSORBING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.restart()
			charging_particles.emitting = false
			charge_particles_timer.stop()
			absorb_particles.emitting = true
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.HOLDING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.restart()
			charging_particles.emitting = false
			charge_particles_timer.stop()
			absorb_particles.restart()
			absorb_particles.emitting = false
			if player.get_gun_state() == Player.HOLDING_STATE:
				if player.get_gun_state_node().is_holding_shot():
					shader.set_shader_param("flash_yellow", 1.0)
					player_shader.set_shader_param("flash_yellow", 1.0)
				elif player.get_gun_state_node().is_holding_rocket():
					shader.set_shader_param("flash_yellow", 1.0)
					player_shader.set_shader_param("flash_yellow", 1.0)
		
		Player.SHOOTING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.restart()
			charging_particles.emitting = false
			charge_particles_timer.stop()
			absorb_particles.restart()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGING_STATE:
			multi_aim_case(player.aiming, player.facing)
			absorb_particles.restart()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGED_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.emitting = true
			absorb_particles.restart()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 1.0)
			player_shader.set_shader_param("flash_yellow", 1.0)



func multi_aim_case(aim: Vector2, facing: float):
	frame = FORWARD_FRAME
	if facing == 1:
		rotation = aim.angle()
	elif facing == -1:
		rotation = PI - aim.angle()



func spawn_muzzle_flash():
	muzzle_flash.frame = randi()%3
	muzzle_flash.visible = true
	$Muzzle/MuzzleFlash/Timer.start()



func _on_muzzle_flash_timeout():
	muzzle_flash.visible = false



func _charge_particles_timeout():
	charging_particles.emitting = true



