extends Control

onready var bar_nodes: HBoxContainer = $Margin/Hbox/Bar
onready var bar: ProgressBar = $BarSize/ProgressBar
onready var tween: Tween = $Tween
onready var total_hp: int = bar_nodes.get_child_count()



func move_bar(from: int, to: int):
	from = clamp(from, 0, total_hp)  # Just in case
	to = clamp(to, 0, total_hp)
	tween.interpolate_property(bar, "value", from*16, to*16, abs(to - from)*0.5,
							   Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func activate_tank(tank_number: int):
	var node = bar_nodes.get_children()[tank_number - 1]
	node.visible = true
	node.get_node("AnimationPlayer").play("activate")

func deactivate_tank(tank_number: int):
	var node = bar_nodes.get_children()[tank_number - 1]
	node.visible = true



func initialize(max_hp: int):
	for i in range(max_hp):
		bar_nodes.get_children()[i].visible = true
	$BarSize.set("custom_constants/margin_right", 422 - 16*total_hp)
	bar.max_value = 16*total_hp
	self.modulate = Color("ffffff")
	move_bar(0, max_hp)



