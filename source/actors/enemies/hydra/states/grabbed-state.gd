extends EnemyState

var player
var muzzle
var level

onready var hitbox = enemy.get_node("Hitbox/Shape")
onready var charge_particles = enemy.get_node("ChargeParticles")
onready var charge_ball = enemy.get_node("ChargeBall")



func initialize(argument):
	player = argument
	muzzle = player.get_node("Sprite/GunSprite/Muzzle")
	level = get_tree().get_nodes_in_group("level")[0]
	
	hitbox.disabled = true
	enemy.set_collision_mask_bit(0, false)
	enemy.set_collision_mask_bit(1, false)
	enemy.set_collision_mask_bit(2, false)
	
	charge_particles.position = Vector2(10,0)
	charge_ball.position = Vector2(10,0)
	
	animation_player.play("grabbed_resting")
	animation_player.connect("animation_finished", self, "_on_animation_finished")



func exit(next_state):
	enemy.rotation = 0
	hitbox.disabled = false
	enemy.set_collision_mask_bit(0, true)
	enemy.set_collision_mask_bit(1, true)
	enemy.set_collision_mask_bit(2, true)
	
	charge_particles.position = Vector2(0,-8)
	charge_ball.position = Vector2(0,-8)
	charge_particles.restart()
	charge_particles.emitting = false
	charge_ball.visible = false



func _physics_process(delta):
	enemy.position = level.to_local(muzzle.global_position) + player.aiming.normalized()*12
	enemy.rotation = player.aiming.angle()



func _on_animation_finished(anim_name: String):
	match anim_name:
		"grabbed_resting":
			charge_particles.emitting = true
			charge_ball.visible = true
			animation_player.play("grabbed_charging")
		"grabbed_charging":
			charge_particles.restart()
			charge_particles.emitting = false
			charge_ball.visible = false
			enemy.spawn_shot(player.aiming)
			animation_player.play("grabbed_resting")
			
			# Hidden mechanic (exploit, actually): when grabbing the hydra,
			# you can combo the recoil of a hydra shot into the recoil of
			# shooting the hydra for a triple jump!
			player.apply_recoil_knockback(-player.aiming)




