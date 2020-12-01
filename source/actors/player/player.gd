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

onready var sfx = $SoundEffects



### MOVEMENT STATES MACHINES #############################################
onready var movement_machine = $MovementStatesMachine
onready var checkpoint: Vector2 = self.position
onready var left_safety: Area2D = $LeftSafety
onready var right_safety: Area2D = $RightSafety

enum {GROUNDED_STATE, AIRBORNE_STATE, JUMPING_STATE, WALL_GRABBING_STATE,
	  WALL_JUMPING_STATE, HANGING_STATE, FLOATING_STATE, ROCKETING_STATE,
	  STUNNED_STATE, DYING_STATE}

func get_movement_state() -> int:
	return movement_machine.state_number

func change_movement_state(new_state: int, argument = null):
	movement_machine.change_state(new_state, argument)

func get_movement_state_node():
	return movement_machine.get_state_node()

func safety_check():
	if left_safety.get_overlapping_bodies().size() > 0:
		if right_safety.get_overlapping_bodies().size() > 0:
			checkpoint = self.position
##########################################################################



### GUN STATES MACHINE ###################################################
onready var gun_machine = $GunStatesMachine
enum {READY_STATE, CHARGING_STATE, CHARGED_STATE, SHOOTING_STATE,
	  ABSORBING_STATE, HOLDING_STATE, UNUSABLE_STATE}

func get_gun_state() -> int:
	return gun_machine.state_number

func change_gun_state(new_state: int, argument = null):
	gun_machine.change_state(new_state, argument)

func get_gun_state_node():
	return gun_machine.get_state_node()
##########################################################################



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
	if abs(velocity.x) <= speed:
		if velocity.x > 0:
			velocity.x = clamp(velocity.x + delta_v*delta*factor, 0, speed)
		elif velocity.x < 0:
			velocity.x = clamp(velocity.x - delta_v*delta*factor, -speed, 0)
		else:
			velocity.x = delta_v*delta*factor*main.get_dir_input().x
	
	# In case of getting knocked back faster than max speed.
	else:
		velocity.x -= friction*sign(velocity.x)*delta*factor
	
	# Lastly, let's change the direction the player is facing.
	if main.get_dir_input().x != 0:
		facing = main.get_dir_input().x

func vertical_movement(delta, factor: float = 1.0):
	velocity.y += gravity*delta*factor
	if velocity.y > falling_speed:
		velocity.y = falling_speed

func drop_from_platforms():
	if $DropTimer.is_stopped():
		self.set_collision_mask_bit(2, false)
		$DropTimer.start()

func _on_drop_timeout():
	self.set_collision_mask_bit(2, true)

func apply_recoil_knockback(direction: Vector2):
	change_movement_state(AIRBORNE_STATE)
	if direction.y == -1:
		velocity.y = -jump_force
	elif direction.y == 1:
		velocity.y += falling_speed
	else:
		velocity.y = min(-jump_force/1.41421, velocity.y)
	if direction.x != 0:
		if velocity.x > 0:
			velocity.x = speed*direction.x
		else:
			velocity.x = 2*speed*direction.x
##########################################################################



### COMBAT ###############################################################
onready var aiming: Vector2 = Vector2.RIGHT
onready var muzzle: Node2D = $Sprite/GunSprite/Muzzle
onready var invincibility: Timer = $InvincibilityTimer

func spawn_shot(shot_scene: PackedScene):
	var level = get_tree().get_nodes_in_group("level")[0]
	var shot = shot_scene.instance()
	shot.shooter = self
	shot.suckable = false
	shot.direction = aiming.normalized()
	shot.position = level.to_local(muzzle.global_position)
	level.add_child(shot)

func hit(source):
	if invincibility.is_stopped():
		match source.type:
			"Light":
				take_damage(1)
			"Heavy", "Mega", "Explosion":
				take_damage(2)

func take_damage(damage: int, touched_spikes: bool = false):
	if invincibility.is_stopped() or touched_spikes:
		main.hp_bar.move_bar(main.data.hp, main.data.hp - damage)
		main.data.hp -= damage
		if main.data.hp > 0:
			change_movement_state(STUNNED_STATE, touched_spikes)
			change_gun_state(UNUSABLE_STATE)
		else:
			change_movement_state(DYING_STATE)
			change_gun_state(UNUSABLE_STATE)

func _on_touched_spikes(body):
	if get_movement_state() != DYING_STATE:
		take_damage(1, true)
##########################################################################



func _ready():
	movement_machine.start_machine(GROUNDED_STATE)
	gun_machine.start_machine(READY_STATE)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)








