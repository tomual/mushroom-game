extends Area2D


signal interactable_available(position)
signal interactable_unavailable()
signal pickup(node)


var in_range = false
var being_held = false
var player


func _ready():
	player = get_tree().get_nodes_in_group("player")[0]


func _process(delta):
	if in_range and !being_held:
		if Input.is_action_pressed("ui_accept"):
			emit_signal("pickup", get_parent())
			in_range = false
			being_held = true
			$CollisionShape2D.disabled = true
			emit_signal("interactable_unavailable")
	if being_held:
		if Input.is_action_pressed("ui_cancel"):
			emit_signal("drop", get_parent())
			in_range = true
			being_held = false
			$CollisionShape2D.disabled = false
			emit_signal("interactable_available", get_parent().position)
		var offset_x = 0
		var offset_y = 0
		if (player.flipped):
			offset_x = -20
		else:
			offset_x = 20
		if player.facing == "t":
			offset_y = -6
		else:
			offset_y = 3
		get_parent().position = Vector2(player.position.x + offset_x, player.position.y + offset_y)
		get_parent().flip_h = player.flipped


func _on_Interactable_area_entered(area):
	if (!being_held):
		emit_signal("interactable_available", get_parent().position)
		in_range = true


func _on_Interactable_area_exited(area):
	if (!being_held):
		emit_signal("interactable_unavailable")
		in_range = false
