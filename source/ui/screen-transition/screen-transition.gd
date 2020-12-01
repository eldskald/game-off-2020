extends TextureRect

export (float) var hide
onready var shader: ShaderMaterial = get_material()
onready var animation_player = $AnimationPlayer
onready var timer = $Timer
onready var end_timer = $EndTimer

func _process(_delta):
	shader.set_shader_param("hide", hide)

func close_screen():
	animation_player.play("out")

func open_screen():
	animation_player.play("in")

func end_game_out():
	animation_player.play("end_game_out")

func end_game_in():
	animation_player.play("end_game_in")


