extends EnemyState

var player
var muzzle
var level

onready var hitbox = enemy.get_node("Hitbox/Shape")



func initialize(argument):
	player = argument
	muzzle = player.get_node("Sprite/GunSprite/Muzzle")
	level = get_tree().get_nodes_in_group("level")[0]
	
	hitbox.disabled = true
	enemy.set_collision_mask_bit(0, false)
	enemy.set_collision_mask_bit(1, false)
	enemy.set_collision_mask_bit(2, false)
	
	animation_player.play("grabbed")



func exit(next_state):
	enemy.rotation = 0
	hitbox.disabled = false
	enemy.set_collision_mask_bit(0, true)
	enemy.set_collision_mask_bit(1, true)
	enemy.set_collision_mask_bit(2, true)



func _physics_process(delta):
	enemy.position = level.to_local(muzzle.global_position) + player.aiming.normalized()*2
	enemy.rotation = player.aiming.angle()
