extends Sprite

func _ready():
	$AnimationPlayer.play("waving")
	$AnimationPlayer.advance(float(randi()%4)/10.0)
