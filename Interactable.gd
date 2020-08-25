extends Area2D

signal interactable_available(position, type)
signal interactable_unavailable()
signal pickup(node)
signal talk(id)

export var id = 0

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
	TALK: "Talk",
	LOOK: "Look",
	MOVE: "Move"
}

var in_range = false
var active = false
var player

var cooldown
var label_offset_x
var label_offset_y
var type
var timer_interact_cooldown

func set_player():
	player = get_tree().get_nodes_in_group("player")[0]


func _ready():
	self.connect("area_entered", self, "_on_Interactable_area_entered")
	self.connect("area_exited", self, "_on_Interactable_area_exited")
	cooldown = Timer.new()
	cooldown.wait_time = 0.5
	cooldown.one_shot = true
	add_child(cooldown)


func _process(delta):
	if in_range and !active:
		show_label()
		if Input.is_action_pressed("ui_accept") and cooldown.is_stopped():
			activate()
	if active and type == HOLD:
		if Input.is_action_pressed("ui_cancel"):
			emit_signal("drop", self)
			$CollisionShape2D.disabled = false
			$Shadow.visible = true
			deactivate()
		var offset_x = 0
		var offset_y = 0
		if (player.flipped):
			offset_x = -20
		else:
			offset_x = 20
		offset_y = -10
		position = Vector2(player.position.x + offset_x, player.position.y + offset_y)
		$AnimatedSprite.flip_h = player.flipped


func _on_Interactable_area_entered(area):
	if (!active):
		show_label()
		in_range = true


func _on_Interactable_area_exited(area):
	if (!active):
		emit_signal("interactable_unavailable")
		in_range = false


func show_label():
	var position_on_screen = get_global_transform_with_canvas()
	var label_position = Vector2(position_on_screen[2][0] - label_offset_x, position_on_screen[2][1] - label_offset_y)
	emit_signal("interactable_available", label_position, labels[type])


func activate():
	print_debug("activate")
	in_range = false
	active = true
	emit_signal("interactable_unavailable")
	if type == HOLD:
		emit_signal("pickup", self)
		$CollisionShape2D.disabled = true
		$Shadow.visible = false
	elif type == TALK:
		emit_signal("talk", id)


func deactivate():
	print_debug("deactivate")
	in_range = true
	active = false
	show_label()
	cooldown.start()
	#	emit_signal("interactable_available", position)
