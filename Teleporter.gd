extends "Interactable.gd"

signal fade_out()

export var to = "House"
export var from = "Home"

func _ready():
	type = MOVE
	label_offset_x = 24
	label_offset_y = 100


func activate():
	.activate()
	print_debug('teley activate')
	$TimerFadeOut.start()
	hud.fade_out()


func _on_TimerFadeOut_timeout():
	main.move(to)
