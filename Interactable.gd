extends Area2D

signal interactable_available(position, type)
signal interactable_unavailable()
signal pickup(node)

enum {
	PICKUP,
	HOLD,
	TALK,
	LOOK,
	MOVE
}

var labels = {
	PICKUP: "Pick Up",
	HOLD: "Hold",
	TALK: "Move",
	LOOK: "Look",
	MOVE: "Move"
}

var in_range = false
var active = false
var player

var label_offset_x
var label_offset_y
var type


func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	self.connect("area_entered", self, "_on_Interactable_area_entered")
	self.connect("area_exited", self, "_on_Interactable_area_exited")


func _process(delta):
	if in_range and !active:
		if Input.is_action_pressed("ui_accept"):
			if type == HOLD:
				emit_signal("pickup", self)
				in_range = false
				active = true
				$CollisionShape2D.disabled = true
				emit_signal("interactable_unavailable")
			elif type == MOVE:
				print_debug("Let's mooooooooooove")
	if active and type == HOLD:
		if Input.is_action_pressed("ui_cancel"):
			emit_signal("drop", self)
			in_range = true
			active = false
			$CollisionShape2D.disabled = false
			emit_signal("interactable_available", position)
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
		position = Vector2(player.position.x + offset_x, player.position.y + offset_y)
		$AnimatedSprite.flip_h = player.flipped


func _on_Interactable_area_entered(area):
	if (!active):
		var label_position = Vector2(position.x - label_offset_x, position.y - label_offset_y)
		emit_signal("interactable_available", label_position, labels[type])
		in_range = true


func _on_Interactable_area_exited(area):
	if (!active):
		emit_signal("interactable_unavailable")
		in_range = false
