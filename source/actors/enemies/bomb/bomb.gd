extends KinematicBody2D

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

export (PackedScene) var explosion
export (PackedScene) var light_shot
export (PackedScene) var heavy_shot

export (float, 0, 2000) var suck_acceleration
export (float, 0, 2000) var friction
export (float, -1, 10, 0.1) var starting_animation_frame

onready var sprite: Sprite = get_node("Sprite")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var sfx = get_node("SoundEffects")
onready var hitbox = get_node("Hitbox")
onready var hurtbox = get_node("Hurtbox")
onready var shot_hitbox = get_node("ShotHitbox")



### STATES MACHINE #######################################################
onready var machine = $StatesMachine
enum {READY_STATE, REFLECTING_LIGHT_SHOT_STATE, REFLECTING_HEAVY_SHOT_STATE,
	  GRABBED_STATE, SHOT_STATE, DEAD_STATE}

func get_state() -> int:
	return machine.state_number

func change_state(new_state: int, argument = null):
	machine.change_state(new_state, argument)

func get_state_node():
	return machine.get_state_node()
##########################################################################



### PHYSICS ##############################################################
onready var velocity: Vector2 = Vector2.ZERO

func apply_friction(delta):
	var new_vel = clamp(velocity.length() - friction*delta, 0, 1000)
	velocity = velocity.normalized()*new_vel

func vacuum_suck(delta):
	var muzzle = hitbox.get_overlapping_areas()[0].get_parent()
	var distance = muzzle.global_position - self.global_position
	velocity += distance.normalized()*suck_acceleration*delta
	var dif_angle = distance.angle() - velocity.angle()
	velocity = velocity.rotated(min(2*PI*delta, abs(dif_angle))*sign(dif_angle))

func is_being_sucked() -> bool:
	return hitbox.get_overlapping_areas().size() > 0
##########################################################################



### COMBAT ###############################################################
func spawn_shot(shot: PackedScene, direction: Vector2):
	var level = get_tree().get_nodes_in_group("level")[0]
	var shot_node = shot.instance()
	shot_node.position = level.to_local(self.global_position) + direction*12
	shot_node.shooter = self
	shot_node.direction = direction
	shot_node.speed = 100
	level.add_child(shot_node)
	sfx.get_node("Shot").play()

func hit(source):
	match source.type:
		"Light":
			source.destroy()
			if get_state() == READY_STATE:
				change_state(REFLECTING_LIGHT_SHOT_STATE, -source.direction)
			elif get_state() in [GRABBED_STATE, SHOT_STATE]:
				self.destroy()
		"Heavy":
			source.destroy()
			if get_state() == READY_STATE:
				change_state(REFLECTING_HEAVY_SHOT_STATE, -source.direction)
			elif get_state() in [GRABBED_STATE, SHOT_STATE]:
				self.destroy()
		_:
			self.destroy()

func _on_hitbox_body_entered(body):
	if body.get_collision_layer_bit(0) == true: # Player layer
		body.take_damage(1)
	elif body.get_collision_layer_bit(3) == true: # Spikes layer
		self.destroy()
	elif body.get_collision_layer_bit(4) == true: # Enemies layer
		if body != self:
			self.destroy()

func grabbed(player):
	change_state(GRABBED_STATE, player)

func shoot(direction: Vector2):
	change_state(SHOT_STATE, direction)

func release(direction: Vector2):
	change_state(READY_STATE)
	velocity = direction.normalized()*50

func destroy():
	if get_state() == GRABBED_STATE:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.change_gun_state(Player.READY_STATE)
	change_state(DEAD_STATE)
##########################################################################



### SHOT STATE FUNCTIONS #################################################
var type = "Bomb"

func _on_ShotHitbox_body_entered(body):
	self.destroy()

func _on_ShotHitbox_area_entered(area):
	self.destroy()

func hit_a_wall():
	self.destroy()
##########################################################################



func _ready():
	machine.start_machine(READY_STATE)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)




