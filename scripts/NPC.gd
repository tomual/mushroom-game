extends "Interactable.gd"


func _ready():
	type = TALK


func activate():
	.activate()
	print_debug("hello")
	HUD.open_zap()
	deactivate()
	
