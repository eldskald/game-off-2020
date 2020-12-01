extends Node

onready var bgm_0: AudioStreamPlayer = $Music0
onready var bgm_1: AudioStreamPlayer = $Music1
onready var bgm_2: AudioStreamPlayer = $Music2
onready var bgm_3: AudioStreamPlayer = $Music3
onready var timer: Timer = $TransitionTimer

var current_bgm: int = -1



func stop():
	bgm_0.stop()
	bgm_1.stop()
	bgm_2.stop()
	bgm_3.stop()
	current_bgm = -1



# Links tracks 1 and 2 together.
func play_1():
	if current_bgm == 2:
		timer.stop()
		var pos = bgm_2.get_playback_position()
		if pos < bgm_1.stream.get_length():
			stop()
			bgm_1.play(pos)
			current_bgm = 1
		else:
			timer.start(bgm_2.stream.get_length() - pos)
	elif current_bgm != 1:
		timer.stop()
		stop()
		bgm_1.play()
		current_bgm = 1

func play_2():
	if current_bgm == 1:
		timer.stop()
		var pos = bgm_1.get_playback_position()
		stop()
		bgm_2.play(pos)
		current_bgm = 2
	elif current_bgm != 2:
		timer.stop()
		stop()
		bgm_2.play()
		current_bgm = 2

func _on_TransitionTimer_timeout():
	stop()
	bgm_1.play()
	current_bgm = 1



func play_0():
	if current_bgm != 0:
		stop()
		bgm_0.play()
		current_bgm = 0



func play_3():
	if current_bgm != 3:
		stop()
		bgm_3.play()
		current_bgm = 3





