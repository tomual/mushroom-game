extends "Interactable.gd"

signal fade_out()

func _ready():
	type = MOVE
	label_offset_x = 24
	label_offset_y = 110
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 0.2), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 0.2), Color(1, 1, 1, 0.5), 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 1)
	$Tween.repeat = true;
	$Tween.start()


func activate():
	active = true
	$Timer.start()
	print_debug("We move")
	emit_signal("fade_out")


func _on_Timer_timeout():
	for member in get_tree().get_nodes_in_group("map"):
		member.queue_free()
	var scene = load("res://House.tscn")
	var player = scene.instance()
	get_tree().root.get_node("Main").add_child(player)
