extends KinematicBody2D
class_name Player

var main = get_tree().get_nodes_in_group("main")[0]

export (float, 0, 500)  var speed
export (float, 0, 2000) var acceleration
export (float, 0, 2000) var friction
export (float, 0, 2000) var gravity
export (float, 0, 256)  var jump_height
export (float, 0, 1000) var falling_speed

onready var velocity: Vector2 = Vector2.ZERO
onready var facing: float = 1.0
onready var jump_force: float = sqrt(2*gravity*jump_height)
onready var dt: float = 0.0



func _physics_process(delta):
	dt = delta
	velocity = move_and_slide(velocity, Vector2.UP)



### MOVEMENT #############################################################
func horizontal_movement(delta, factor: float = 1.0):
	# Because of the many different possible combinations of where the
	# player is accelerating towards, where the current velocity points,
	# and whether each is zero or not and then having to clamp it all
	# at the end and I don't want to make dozens of if-else states,
	# I'll work with absolute values instead. 
	var delta_v = 0.0
	
	# Let's handle when the character is braking.
	if main.get_dir_input().x*velocity.x <= 0:
		delta_v -= friction + abs(main.get_dir_input().x)*acceleration
	
	# Now, when it is accelerating towards the velocity's direction.
	else:
		delta_v += abs(main.get_dir_input().x)*acceleration
	
	# Now, let's correctly clamp it.
	if velocity.x >= 0:
		velocity.x = clamp(velocity.x + delta_v*delta*factor, 0, speed)
	else:
		velocity.x = clamp(velocity.x - delta_v*delta*factor, -speed, 0)

func vertical_movement(delta, factor: float = 1.0):
	velocity.y += gravity*delta*factor
	if velocity.y > falling_speed:
		velocity.y = falling_speed
##########################################################################



### STATES MACHINES ######################################################
enum {GROUNDED_STATE, AIRBORNE_STATE, JUMPING_STATE, WALL_GRABBING_STATE,
	  WALL_JUMPING_STATE, STUNNED_STATE, ABSORBED_STATE, ROCKETING_STATE}

enum {READY_STATE, CHARGING_STATE, CHARGED_STATE, SHOOTING_UP, SHOOTING_LEFT,
	  SHOOTING_DOWN, SHOOTING_RIGHT, SUCKING_STATE, HOLDING_STATE, UNUSABLE_STATE}

func get_movement_state():
	return $MovementStatesMachine.stack[0]

func get_gun_state():
	return $GunStatesMachine.stack[0]
##########################################################################


