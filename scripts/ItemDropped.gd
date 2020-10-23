extends "Interactable.gd"

export var item_id = 12
export var item_quantity = 1

func _ready():
	type = PICKUP
	$AnimatedSprite.play()


func activate():
	.activate()
	if player.pickup(item_id, item_quantity):
		queue_free()
	else:
		deactivate()
