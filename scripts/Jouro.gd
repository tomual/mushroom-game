extends "Interactable.gd"


func _ready():
	type = HOLD


func use():
	.use()
	print_debug('jouro use')
