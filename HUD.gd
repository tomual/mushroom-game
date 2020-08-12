extends CanvasLayer

func _ready():
	for member in get_tree().get_nodes_in_group("interactable"):
		print_debug(member)
		member.connect("interactable_available", self, "interactable_available")

func interactable_available(position):
	print_debug("interactable_available")
	print_debug(position)
	$LabelPickUp.set_position(Vector2(position.x - 24, position.y - 50))
	$Tween.interpolate_property($LabelPickUp, "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($LabelPickUp, "rect_scale", Vector2(1.1,1.1), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$Tween.interpolate_property($LabelPickUp, "rect_rotation", 0, 5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.interpolate_property($LabelPickUp, "rect_rotation", 0, -5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$Tween.repeat = true;
	$Tween.start()
