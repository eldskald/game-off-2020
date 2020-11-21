extends EnemyState

var player
var muzzle
var level

onready var hitbox = enemy.get_node("Hitbox/Shape")



func initialize(argument):
	player = argument
	muzzle = player.get_node("Sprite/GunSprite/Muzzle")
	level = get_tree().get_nodes_in_group("level")[0]
	
	enemy.get_parent().remove_child(enemy)
	muzzle.add_child(enemy)
	enemy.position = Vector2(14,0)
	
	hitbox.disabled = true
	enemy.set_collision_mask_bit(0, false)
	enemy.set_collision_mask_bit(1, false)
	enemy.set_collision_mask_bit(2, false)
	
	animation_player.play("grabbed_resting")
	animation_player.connect("animation_finished", self, "_on_animation_finished")



func exit(next_state):
	muzzle.remove_child(enemy)
	level.add_child(enemy)
	enemy.position = level.to_local(muzzle.global_position) + player.aiming*14
	
	hitbox.disabled = false
	enemy.set_collision_mask_bit(0, true)
	enemy.set_collision_mask_bit(1, true)
	enemy.set_collision_mask_bit(2, true)



func _on_animation_finished(anim_name: String):
	match anim_name:
		"grabbed_resting":
			enemy.get_node("ChargeParticles").emitting = true
			enemy.get_node("ChargeBall").visible = true
			animation_player.play("grabbed_charging")
		"grabbed_charging":
			enemy.get_node("ChargeParticles").restart()
			enemy.get_node("ChargeParticles").emitting = false
			enemy.get_node("ChargeBall").visible = false
			enemy.spawn_shot(player.aiming)
			animation_player.play("grabbed_resting")
			
			# Hidden mechanic (exploit, actually): when grabbing the hydra,
			# you can combo the recoil of a hydra shot into the recoil of
			# shooting the hydra for a triple jump!
			player.apply_recoil_knockback(-player.aiming)




