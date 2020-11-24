extends TextureRect

export (float) var hide
onready var shader: ShaderMaterial = get_material()
onready var animation_player = $AnimationPlayer
onready var timer = $Timer

func _process(_delta):
	shader.set_shader_param("hide", hide)

func close_screen():
	$AnimationPlayer.play("out")

func open_screen():
	$AnimationPlayer.play("in")


