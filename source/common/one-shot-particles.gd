extends CPUParticles2D

# This script's function is to allow us to spawn more of the same
# particle effects on the screen at the same time. For example, if
# we make a CPUParticles2D under the muzzle to activate each time
# the player shoots, then when the player tries to shoot concecutively,
# the second shot will not spawn particles if the particles from the
# first shot are still onscreen. That same node cannot spawn particles
# twice. This forces us to spawn one node for each spawn attempt
# instead of just turning on an existing node. Coincidentaly, all
# particle effects that we need multiples of onscreen are one-shot
# particle effects. Hence why this script's existence.

func _ready():
	emitting = true
	one_shot = true

func set_emitting(new_value):
	emitting = new_value
	if new_value == false:
		queue_free()
