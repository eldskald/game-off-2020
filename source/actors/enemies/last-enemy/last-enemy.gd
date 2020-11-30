extends Node2D

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

export (PackedScene) var light_shot
export (PackedScene) var heavy_shot
export (PackedScene) var mega_shot



func _ready():
	unpause_animations()



### REFLECTING SHOTS ######################################################################
onready var timer = $Timer
onready var reflecting_shot = null
onready var heavy_particles = $Sprites/HeavyParticles
onready var mega_particles_1 = $Sprites/MegaParticles1
onready var mega_particles_2 = $Sprites/MegaParticles2

func hit(source):
	if timer.is_stopped():
		match source.type:
			"Light":
				reflecting_shot = light_shot
				timer.start()
				make_yellow()
				pause_animations()
			"Heavy":
				reflecting_shot = heavy_shot
				heavy_particles.emitting = true
				timer.start()
				make_yellow()
				pause_animations()
			"Rocket":
				reflecting_shot = mega_shot
				mega_particles_1.emitting = true
				mega_particles_2.emitting = true
				make_yellow()
				pause_animations()

func spawn_shot(shot: PackedScene):
	var level = get_tree().get_nodes_in_group("level")[0]
	var shot_node = shot.instance()
	shot_node.position = level.to_local($Sprites/Core.global_position)
	shot_node.shooter = self
	shot_node.breaks_on_walls = false
	shot_node.direction = Vector2.LEFT
	shot_node.speed = 100
	level.add_child(shot_node)

func _on_Hurtbox_area_exited(area):
	if area.get_collision_layer_bit(5) == true:
		if area.get_parent().type == "Rocket":
			timer.start()

func _on_Timer_timeout():
	heavy_particles.restart()
	heavy_particles.emitting = false
	mega_particles_1.restart()
	mega_particles_1.emitting = false
	mega_particles_2.restart()
	mega_particles_2.emitting = false
	unpause_animations()
	make_white()
	spawn_shot(reflecting_shot)

func can_be_grabbed():
	return false
###########################################################################################



### ANIMATIONS AND SHADERS ################################################################
onready var main_player = $AnimationPlayer
onready var head_player = $Sprites/Head/AnimationPlayer
onready var core_player = $Sprites/Core/AnimationPlayer

onready var shaders: Array = [
	$Sprites/Head.get_material(), $Sprites/Core.get_material(),
	$Sprites/CenterTentacle1.get_material(),
	$Sprites/CenterTentacle2.get_material(), $Sprites/CenterTentacle3.get_material(),
	$Sprites/BorderTentacle1.get_material(), $Sprites/BorderTentacle2.get_material(),
	$Sprites/BorderTentacle3.get_material(), $Sprites/BorderTentacle4.get_material()
]

func pause_animations():
	paused_shaders = true
	main_player.stop(false)
	head_player.stop(false)
	core_player.stop(false)

func unpause_animations():
	paused_shaders = false
	main_player.play("floating")
	head_player.play("squish")
	core_player.play("twitch")

func make_yellow():
	for shader in shaders:
		shader.set_shader_param("is_yellow", 1.0)

func make_white():
	for shader in shaders:
		shader.set_shader_param("is_yellow", 0.0)
###########################################################################################



### UPDATING TIME ON SHADERS ##############################################################
var paused_shaders: bool = false
var time: float = 0.0

func _process(delta):
	if not paused_shaders:
		time += delta
		for shader in shaders:
			shader.set_shader_param("time", time)
###########################################################################################


