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
onready var rocket_charge: CPUParticles2D = get_parent().get_node("RocketChargeParticles")
onready var mega_rocket: CPUParticles2D = get_parent().get_node("MegaRocketChargeParticles")
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
			rocket_charge.restart()
			rocket_charge.emitting = false
			mega_rocket.restart()
			mega_rocket.emitting = false
			charge_particles_timer.stop()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.UNUSABLE_STATE:
			frame = UNUSABLE_FRAME
			charging_particles.restart()
			charging_particles.emitting = false
			rocket_charge.restart()
			rocket_charge.emitting = false
			mega_rocket.restart()
			mega_rocket.emitting = false
			charge_particles_timer.stop()
			absorb_particles.restart()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.ABSORBING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.restart()
			charging_particles.emitting = false
			rocket_charge.restart()
			rocket_charge.emitting = false
			mega_rocket.restart()
			mega_rocket.emitting = false
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
		
		Player.SHOOTING_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.restart()
			charging_particles.emitting = false
			rocket_charge.restart()
			rocket_charge.emitting = false
			mega_rocket.restart()
			mega_rocket.emitting = false
			charge_particles_timer.stop()
			absorb_particles.restart()
			absorb_particles.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGING_STATE:
			multi_aim_case(player.aiming, player.facing)
			absorb_particles.restart()
			absorb_particles.emitting = false
			rocket_charge.restart()
			rocket_charge.emitting = false
			mega_rocket.restart()
			mega_rocket.emitting = false
			shader.set_shader_param("flash_yellow", 0.0)
			player_shader.set_shader_param("flash_yellow", 0.0)
		
		Player.CHARGED_STATE:
			multi_aim_case(player.aiming, player.facing)
			charging_particles.emitting = true
			absorb_particles.restart()
			absorb_particles.emitting = false
			rocket_charge.restart()
			rocket_charge.emitting = false
			mega_rocket.restart()
			mega_rocket.emitting = false
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



