extends "Interactable.gd"

func _ready():
	type = MOVE
	label_offset_x = 24
	label_offset_y = 60
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 0.2), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 0.2), Color(1, 1, 1, 0.5), 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 1)
	$Tween.repeat = true;
	$Tween.start()
