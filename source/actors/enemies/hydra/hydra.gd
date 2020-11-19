extends KinematicBody2D

onready var main: Main = get_tree().get_nodes_in_group("main")[0]

export (PackedScene) var shot
export (int, 1, 100) var max_hp
export (float, 0, 2000) var friction
export (float, 0, 2000) var suck_acceleration
export (float, 0, 2000) var gravity
export (float, 0, 1000) var falling_speed

export (String, "Horizontal", "Up", "Down", "Left", "Right") var shot_direction
export (String, "Up", "Down", "Left", "Right") var facing

onready var sprite: Sprite = get_node("Sprite")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var hitbox = get_node("Hitbox")
onready var hurtbox = get_node("Hurtbox")
onready var shot_hitbox = get_node("ShotHitbox")



### STATES MACHINE #######################################################
onready var machine = $StatesMachine
enum {READY_STATE, CHARGING_STATE, GRABBED_STATE, SHOT_STATE, STUNNED_STATE,
	  DEAD_STATE, INACTIVE_STATE}

func get_state() -> int:
	return machine.state_number

func change_state(new_state: int, argument = null):
	machine.change_state(new_state, argument)

func get_state_node():
	return machine.get_state_node()

func _on_screen_entered():
	if get_state() != DEAD_STATE:
		machine.change_state(READY_STATE)

func _on_screen_exited():
	if get_state() != DEAD_STATE:
		machine.change_state(INACTIVE_STATE)
##########################################################################



### PHYSICS ##############################################################
onready var velocity: Vector2 = Vector2.ZERO

func vertical_movement(delta):
	velocity.y += gravity*delta
	if velocity.y > falling_speed:
		velocity.y = falling_speed

func horizontal_movement(delta):
	var speed = abs(velocity.x)
	speed -= friction*delta
	if speed < 0:
		speed = 0
	velocity.x = sign(velocity.x)*speed

func vacuum_suck(delta):
	var muzzle = hurtbox.get_overlapping_areas()[0].get_parent()
	var distance = muzzle.global_position - self.global_position
	velocity += distance.normalized()*suck_acceleration*delta
	var dif_angle = distance.angle() - velocity.angle()
	velocity = velocity.rotated(min(2*PI*delta, abs(dif_angle))*sign(dif_angle))

func is_being_sucked() -> bool:
	return hitbox.get_overlapping_areas().size() > 0
##########################################################################



### COMBAT ###############################################################
onready var hp: int = max_hp

func spawn_shot(direction: Vector2):
	var level = get_tree().get_nodes_in_group("level")[0]
	var shot_node = shot.instance()
	shot_node.position = level.to_local($ChargeBall.global_position)
	shot_node.direction = direction
	shot_node.speed = 100
	level.add_child(shot_node)

func get_shot_dir_vector():
	match shot_direction:
		"Horizontal":
			var player = get_tree().get_nodes_in_group("player")[0]
			return Vector2(sign(player.global_position - self.global_position), 0)
		"Up":
			return Vector2.UP
		"Down":
			return Vector2.DOWN
		"Left":
			return Vector2.LEFT
		"Right":
			return Vector2.RIGHT

func hit(source):
	match source.type:
		"Light":
			source.destroy()
			hp -= 1
			if hp == 0:
				self.destroy()
			else:
				if get_state() == GRABBED_STATE:
					self.destroy()
				else:
					change_state(STUNNED_STATE)
		"Rocket":
			self.destroy()
		_:
			source.destroy()
			self.destroy()

func grabbed(player):
	change_state(GRABBED_STATE, player)

func destroy():
	change_state(DEAD_STATE)
##########################################################################



### SHOT STATE FUNCTIONS #################################################
var type = "Hydra"

func _on_ShotHitbox_body_entered(body):
	body.hit(self)

func _on_ShotHitbox_area_entered(area):
	area.hit(self)

func hit_a_wall():
	change_state(READY_STATE)
	velocity *= -0.2
##########################################################################



func _ready():
	if $VisibilityNotifier2D.is_on_screen():
		machine.start_machine(READY_STATE)
	else:
		machine.start_machine(INACTIVE_STATE)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)


