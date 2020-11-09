extends KinematicBody2D
class_name Player

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

export (float, 0, 500) var speed
export (float, 0, 2000) var acceleration
export (float, 0, 2000) var friction
export (float, 0, 2000) var gravity
export (float, 0, 256) var jump_height

export (PackedScene) var light_shot
export (PackedScene) var heavy_shot
export (PackedScene) var rocket_shot



### PHYSICS ##############################################################
onready var velocity: Vector2 = Vector2.ZERO
onready var jump_force: float = sqrt(2*gravity*jump_height)
onready var falling_speed: float = jump_force
onready var facing: float = 1.0

func horizontal_movement(delta, factor: float = 1.0):
	# Because of the many different possible combinations of where the
	# player is accelerating towards, where the current velocity points,
	# and whether each is zero or not and then having to clamp it all
	# at the end and I don't want to make dozens of if-else states, I'll
	# work with absolute values instead. 
	var delta_v = 0.0
	
	# Let's handle when the character is braking.
	if main.get_dir_input().x*velocity.x <= 0 and velocity.x != 0:
		delta_v -= friction + abs(main.get_dir_input().x)*acceleration
	
	# Now, when it is accelerating towards the velocity's direction.
	else:
		delta_v += abs(main.get_dir_input().x)*acceleration
	
	# Now, let's correctly clamp it.
	if velocity.x > 0:
		velocity.x = clamp(velocity.x + delta_v*delta*factor, 0, speed)
	elif velocity.x < 0:
		velocity.x = clamp(velocity.x - delta_v*delta*factor, -speed, 0)
	else:
		velocity.x = delta_v*delta*factor*main.get_dir_input().x
	
	# Lastly, let's change the direction the player is facing.
	if main.get_dir_input().x != 0:
		facing = main.get_dir_input().x

func vertical_movement(delta, factor: float = 1.0):
	velocity.y += gravity*delta*factor
	if velocity.y > falling_speed:
		velocity.y = falling_speed
##########################################################################



### GUNNING ##############################################################
onready var aiming: Vector2 = Vector2.RIGHT
onready var muzzle: Node2D = $Sprite/GunSprite/Muzzle

func spawn_light_shot():
	var shot = light_shot.instance()
	shot.direction = aiming
	shot.position = get_parent().to_local(muzzle.global_position)
	shot.position += aiming*8
	get_parent().add_child(shot)

func spawn_heavy_shot():
	var shot = heavy_shot.instance()
	shot.direction = aiming
	shot.position = get_parent().to_local(muzzle.global_position)
	shot.position += aiming*12
	get_parent().add_child(shot)
##########################################################################



### STATES MACHINES ######################################################
enum {GROUNDED_STATE, AIRBORNE_STATE, JUMPING_STATE, WALL_GRABBING_STATE,
	  WALL_JUMPING_STATE, STUNNED_STATE, FLOATING_STATE, ROCKETING_STATE}

onready var movement_machine = $MovementStatesMachine

func get_movement_state() -> int:
	return movement_machine.state_number

func change_movement_state(new_state: int, special: bool = false):
	if special:
		return movement_machine.change_state(new_state, true)
	else:
		movement_machine.change_state(new_state)

func get_movement_state_node():
	return movement_machine.get_state_node()

enum {READY_STATE, CHARGING_STATE, CHARGED_STATE, SHOOTING_STATE,
	  SUCKING_STATE, HOLDING_STATE, UNUSABLE_STATE}

onready var gun_machine = $GunStatesMachine

func get_gun_state() -> int:
	return gun_machine.state_number

func change_gun_state(new_state: int, special: bool = false):
	if special:
		return gun_machine.change_state(new_state, true)
	else:
		gun_machine.change_state(new_state)

func get_gun_state_node():
	return gun_machine.get_state_node()
##########################################################################



func _ready():
	movement_machine.start_machine(GROUNDED_STATE)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)


