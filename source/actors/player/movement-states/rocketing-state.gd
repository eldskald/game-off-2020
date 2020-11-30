extends PlayerState

var timer
var rocket
var rocket_animation



func initialize(argument):
	camera.drag_margin_top = 0.7
	player.set_collision_mask_bit(2, false)
	
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")
	
	if argument == true:
		rocket = muzzle.get_node("MegaRocket")
		player.set_collision_mask_bit(1, false)
		timer.start(29.6)
	else:
		rocket = muzzle.get_node("RocketLaser")
		timer.start(2.6)
	
	rocket_animation = rocket.get_node("AnimationPlayer")
	rocket_animation.connect("animation_finished", self, "_on_animation_finished")
	rocket.activate()



func exit(next_state):
	rocket.deactivate_instantly()
	player.set_collision_mask_bit(1, true)
	player.set_collision_mask_bit(2, true)



func _on_timeout():
	rocket.deactivate()

func _on_animation_finished(anim_name):
	if anim_name == "deactivate":
		player.change_movement_state(Player.AIRBORNE_STATE)



func _physics_process(_delta):
	player.velocity = -player.aiming*200




