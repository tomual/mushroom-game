extends "Interactable.gd"


func _ready():
	type = HOLD
	label_offset_x = 24
	label_offset_y = 100


func use():
	.use()
	print_debug('jouro use')
