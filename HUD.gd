extends CanvasLayer

func _ready():
	$LabelPickUp.visible = false
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("interactable_available", self, "interactable_available")
		member.connect("interactable_unavailable", self, "interactable_unavailable")

func interactable_available(position):
	print_debug("interactable_available")
	$LabelPickUp.visible = true
	$LabelPickUp.set_position(Vector2(position.x - 24, position.y - 50))
	$Tween.interpolate_property($LabelPickUp, "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($LabelPickUp, "rect_scale", Vector2(1.1,1.1), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$Tween.interpolate_property($LabelPickUp, "rect_rotation", 0, 5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.interpolate_property($LabelPickUp, "rect_rotation", 5, -5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$Tween.repeat = true;
	$Tween.start()

func interactable_unavailable():
	print_debug("interactable_unavailable")
	$LabelPickUp.visible = false
	$Tween.stop_all()
