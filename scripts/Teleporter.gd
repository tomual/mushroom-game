extends "Interactable.gd"

signal fade_out()

export var to = "House"
export var from = "Home"
export var dungeon = false


func _ready():
	type = MOVE


func activate():
	if !HUD.talking:
		.activate()
		if dungeon:
			HUD.open_dungeon()
		else:
			$TimerFadeOut.start()
			HUD.fade_out()


func _on_TimerFadeOut_timeout():
	Global.move(to)
