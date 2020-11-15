extends Area2D

signal interactable_available(position, type)
signal interactable_unavailable()
signal interactable_in_range(in_range)
signal drop(node)
signal talk(id)
signal set_busy()
signal set_idle()

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
var label_offset_x = 60
var label_offset_y = 70
var type
var timer_interact_cooldown
var hud


func set_player(node):
	player = node


func _ready():
	self.connect("area_entered", self, "_on_Interactable_area_entered")
	self.connect("area_exited", self, "_on_Interactable_area_exited")
	cooldown = Timer.new()
	cooldown.wait_time = 0.5
	cooldown.one_shot = true
	add_child(cooldown)
		
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member


func _process(delta):
	if in_range and !active:
		show_label()
		if Input.is_action_pressed("ui_accept") and cooldown.is_stopped():
			activate()
	elif active and type == HOLD:
		if Input.is_action_pressed("fire") and cooldown.is_stopped():
			use()
		if Input.is_action_pressed("ui_accept") and cooldown.is_stopped():
			emit_signal("drop", self)
			$CollisionShape2D.disabled = false
			$Shadow.visible = true
			deactivate()
		var offset_x = 0
		var offset_y = 0
		if player.flipped:
			offset_x = -13
		else:
			offset_x = 13
		offset_y = -13
		position = Vector2(player.position.x + offset_x, player.position.y + offset_y)
		
		$AnimatedSprite.flip_h = player.flipped


func _on_Interactable_area_entered(area):
	if !active and area.name == "AreaPlayer":
		show_label()
		in_range = true
		emit_signal("interactable_in_range", in_range)


func _on_Interactable_area_exited(area):
	if !active and area.name == "AreaPlayer":
		emit_signal("interactable_unavailable")
		in_range = false
		emit_signal("interactable_in_range", in_range)


func show_label():
	var position_on_screen = get_global_transform_with_canvas()
	var label_position = Vector2(position_on_screen[2][0] - label_offset_x, position_on_screen[2][1] - label_offset_y)
	emit_signal("interactable_available", label_position, labels[type])


func use():
	print_debug("use")
	cooldown.start()


func activate():
	print_debug("activate")
	cooldown.start()
	in_range = false
	active = true
	emit_signal("interactable_unavailable")
	if type == HOLD:
		player.hold(self)
		$CollisionShape2D.disabled = true
		$Shadow.visible = false


func deactivate():
	print_debug("deactivate")
	cooldown.start()
	in_range = true
	active = false
	show_label()
	#	emit_signal("interactable_available", position)
