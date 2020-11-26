extends "Interactable.gd"

export var item_id = 5
export var item_quantity = 1


func _ready():
	type = PICKUP
	$AnimatedSprite.play()


func init():
	HUD.set_listen_interactable(self)
	for member in get_tree().get_nodes_in_group("player"):
		player = member
		player.set_listen_interactable(self)


func activate():
	.activate()
	if player.pickup(item_id, item_quantity):
		deactivate()
		queue_free()
	else:
		deactivate()


