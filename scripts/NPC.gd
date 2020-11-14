extends "Interactable.gd"


func _ready():
	type = TALK


func activate():
	.activate()
	print_debug("hello")
	hud.open_zap()
	deactivate()
	
