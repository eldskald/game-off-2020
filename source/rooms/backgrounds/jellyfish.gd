extends Sprite

func _ready():
	$AnimationPlayer.playback_speed = 1.0/(3 + (randi()%40)/10)
	$AnimationPlayer.play("bobble")
	get_material().set_shader_param("amplitude", (randi()%30)/10 + 2)
	get_material().set_shader_param("wavelength", (randi()%50)/10 + 5)
	get_material().set_shader_param("frequency", (randi()%90)/10 + 1)
	get_material().set_shader_param("phase", (randi()%100)/10)
