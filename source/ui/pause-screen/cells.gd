extends GridContainer

# They are ordered in a grid, so cell 24 is row 2 column 4. Don't forget that
# row 0 and column 0 are where it starts.
onready var room_cells: Array = [
	[$"05"],                                                       # Room  0
	[$"06"],                                                       # Room  1
	[$"02", $"03", $"04"],                                         # Room  2
	[$"12"],                                                       # Room  3
	[$"11"],                                                       # Room  4
	[$"13", $"23"],                                                # Room  5
	[$"14"],                                                       # Room  6
	[$"33", $"34", $"43", $"44", $"53", $"54", $"63", $"64"],      # Room  7
	[$"73"],                                                       # Room  8
	[$"42"],                                                       # Room  9
	[$"71", $"72"],                                                # Room 10
	[$"41", $"51", $"61"],                                         # Room 11
	[$"82"],                                                       # Room 12
	[$"40"],                                                       # Room 13
	[$"35", $"36", $"37"],                                         # Room 14
	[$"26"],                                                       # Room 15
	[$"65"],                                                       # Room 16
	[$"46", $"47", $"56", $"57", $"66", $"67"],                    # Room 17
	[$"77"],                                                       # Room 18
	[$"76"],                                                       # Room 19
	[$"86"],                                                       # Room 20
	[$"58"],                                                       # Room 21
	[$"39", $"49", $"59"],                                         # Room 22
	[$"68"]                                                        # Room 23
]

const TRANSPARENT: Rect2 = Rect2(0,0,32,18)
const BLACK: Rect2 = Rect2(32,0,32,18)
const EGG: Rect2 = Rect2(64,0,32,18)
const TANK: Rect2 = Rect2(96,0,32,18)




