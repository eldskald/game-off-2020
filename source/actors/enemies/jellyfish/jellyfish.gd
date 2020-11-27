extends KinematicBody2D

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

export (String, "Static", "Up", "Left", "Down", "Right") var moving
export (float, 0, 500) var moving_speed
export (float, 0, 2000) var suck_acceleration
export (float, -1, 10, 0.1) var starting_animation_frame

onready var sprite: Sprite = get_node("Sprite")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var hitbox = get_node("Hitbox")
onready var hurtbox = get_node("Hurtbox")
onready var shot_hitbox = get_node("ShotHitbox")



### STATES MACHINE #######################################################
onready var machine = $StatesMachine
enum {READY_STATE, GRABBED_STATE, SHOT_STATE, DEAD_STATE}

func get_state() -> int:
	return machine.state_number

func change_state(new_state: int, argument = null):
	machine.change_state(new_state, argument)

func get_state_node():
	return machine.get_state_node()
##########################################################################



### PHYSICS ##############################################################
var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

func starting_velocity():
	match moving:
		"Static":
			activate_wall_collisions()
			acceleration = Vector2(0, 32/9) # To sync up the bobbing up and down animation
			velocity = Vector2.ZERO
		"Up":
			deactivate_wall_collisions()
			acceleration = Vector2.ZERO
			velocity = moving_speed*Vector2.UP
		"Left":
			deactivate_wall_collisions()
			acceleration = Vector2.ZERO
			velocity = moving_speed*Vector2.LEFT
		"Down":
			deactivate_wall_collisions()
			acceleration = Vector2.ZERO
			velocity = moving_speed*Vector2.DOWN
		"Right":
			deactivate_wall_collisions()
			acceleration = Vector2.ZERO
			velocity = moving_speed*Vector2.RIGHT

func swim_up():
	if moving == "Static":
		velocity = Vector2(0, -32)
		acceleration = Vector2(0, 32)

func vacuum_suck(delta):
	var muzzle = hitbox.get_overlapping_areas()[0].get_parent()
	var distance = muzzle.global_position - self.global_position
	velocity += distance.normalized()*suck_acceleration*delta
	var dif_angle = distance.angle() - velocity.angle()
	velocity = velocity.rotated(min(2*PI*delta, abs(dif_angle))*sign(dif_angle))

func is_being_sucked() -> bool:
	return hitbox.get_overlapping_areas().size() > 0

func deactivate_wall_collisions():
	self.set_collision_mask_bit(1, false)
	hitbox.set_collision_mask_bit(3, false)

func activate_wall_collisions():
	self.set_collision_mask_bit(1, true)
	hitbox.set_collision_mask_bit(3, true)
##########################################################################

### COMBAT ###############################################################
func hit(source):
	self.destroy()
	if source.type != "Heavy":
		source.destroy()

func _on_hitbox_body_entered(body):
	if body.get_collision_layer_bit(0) == true: # Player layer
		body.take_damage(1)
	elif body.get_collision_layer_bit(3) == true: # Spikes layer
		self.destroy()
	elif body.get_collision_layer_bit(4) == true: # Enemies layer
		if body != self:
			body.hit(self)

func grabbed(player):
	change_state(GRABBED_STATE, player)
	moving = "Static"

func shoot(direction: Vector2):
	change_state(SHOT_STATE, direction)

func release(direction: Vector2):
	shoot(direction)

func destroy():
	if get_state() == GRABBED_STATE:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.change_gun_state(Player.READY_STATE)
	change_state(DEAD_STATE)
##########################################################################



### SHOT STATE FUNCTIONS #################################################
var type = "Jellyfish"

func _on_ShotHitbox_body_entered(body):
	body.hit(self)

func _on_ShotHitbox_area_entered(area):
	area.get_parent().hit(self) 

func hit_a_wall():
	self.destroy()
##########################################################################



func _ready():
	machine.start_machine(READY_STATE)
	starting_velocity()

func _physics_process(delta):
	velocity += acceleration*delta
	velocity = move_and_slide(velocity, Vector2.UP)



