extends Node



func step():
	$Step.pitch_scale = float(randi()%5 + 8)/10.0
	$Step.play()

func jump():
	$Jump.pitch_scale = float(randi()%5 + 8)/10.0
	$Jump.play()



func shot():
	$Shot.play()

func damage():
	$Damage.play()

func catch():
	$Catch.pitch_scale = 1.5
	$Catch.play()

func pickup():
	$Catch.pitch_scale = 1.0
	$Catch.play()



func charge(play: bool):
	if play:
		$Charge.play()
	else:
		$Charge.stop()

func absorb(play: bool):
	if play:
		$Absorb.play()
	else:
		$Absorb.stop()

func rocket(play: bool):
	if play:
		$Rocket.play()
	else:
		$Rocket.stop()


