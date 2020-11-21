extends EnemyState

var direction: Vector2 = Vector2.ZERO

onready var hurtbox = enemy.get_node("Hurtbox")
onready var hitbox = enemy.get_node("Hitbox/Shape")
onready var shot_hitbox = enemy.get_node("ShotHitbox/Shape")



func initialize(argument):
	direction = argument
	shot_hitbox.disabled = false
	hurtbox.disabled = true
	hitbox.disabled = true



func exit(next_state):
	shot_hitbox.disabled = true
	hurtbox.disabled = false
	hitbox.disabled = false



func _physics_process(delta):
	enemy.velocity = 300*direction


