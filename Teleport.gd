extends "Interactable.gd"

signal fade_out()

export var target = "Home"

func _ready():
	type = MOVE
	label_offset_x = 24
	label_offset_y = 110
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 0.5), Color(1, 1, 1, 0.2), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 0.2), Color(1, 1, 1, 0.5), 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 1)
	$Tween.repeat = true;
	$Tween.start()


func activate():
	print_debug("activate")
	in_range = false
	active = true
	emit_signal("interactable_unavailable")
	$Timer.start()
	emit_signal("fade_out")


func _on_Timer_timeout():
	for member in get_tree().get_nodes_in_group("map"):
		member.delete()
	var scene = load("res://" + target + ".tscn")
	var map = scene.instance()
	get_tree().root.get_node("Main").add_child(map)
