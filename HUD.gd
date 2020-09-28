extends CanvasLayer

signal hud_line_complete()
signal option_1_pressed()
signal option_2_pressed()
signal player_set_idle()
signal player_set_busy()


var talking = false
var talk_line_cursor = 0
var talk_line = ""
var player


func _ready():
	init()
	$PlayerFrames.visible = false


func _process(delta):
	if talking and talk_line.length() >= talk_line_cursor + 1:
		$Dialogue/LabelDialogue.text = $Dialogue/LabelDialogue.text + talk_line[talk_line_cursor]
		talk_line_cursor = talk_line_cursor + 1
		if talk_line.length() <= talk_line_cursor + 1:
			talk_complete_line()
	var player_screen_position = player.get_global_transform_with_canvas()[2]
	$PlayerFrames.margin_left = player_screen_position[0] - 50
	$PlayerFrames.margin_top = player_screen_position[1] - 80
	$PlayerFrames.rect_size = Vector2(100, 100)


func init():
	fade_in()
	init_label_interactive()
	init_listeners()
	talk_hide()
	options_hide()


func set_player():
	player = get_tree().get_nodes_in_group("player")[0]
	player.connect("update_health", self, "update_hp")
	player.connect("die", self, "death_screen")


func interactable_available(position, label):
	# print_debug("interactable_available")
	$LabelInteractable.text = label
	$LabelInteractable.visible = true
	$LabelInteractable.set_position(position)
	$TweenInteractable.start()


func interactable_unavailable():
	# print_debug("interactable_unavailable")
	$LabelInteractable.visible = false


func fade_out():
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.37, 0.37, 0.71, 0), Color(0.37, 0.37, 0.71, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func fade_in():
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.37, 0.37, 0.71, 1), Color(0.37, 0.37, 0.71, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func init_listeners():
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("interactable_available", self, "interactable_available")
		member.connect("interactable_unavailable", self, "interactable_unavailable")
		member.connect("fade_out", self, "fade_out")
		member.connect("talk_show", self, "talk_show")
		member.connect("talk_hide", self, "talk_hide")
		member.connect("talk_complete_line", self, "talk_complete_line")
		member.connect("options_show", self, "options_show")
		member.connect("options_hide", self, "options_hide")


func init_label_interactive():
	$LabelInteractable.visible = false
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1.1,1.1), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 0, 5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 5, -5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)


func talk_show(line):
	print_debug("talk_show")
	emit_signal("player_set_busy")
	$Dialogue/LabelDialogue.text = ""
	$Dialogue.show()
	talking = true
	talk_line_cursor = 0
	talk_line = line


func talk_hide():
	emit_signal("player_set_idle")
	$Dialogue.hide()
	talking = false
	talk_line_cursor = 0
	talk_line = ""


func options_hide():
	$Options.hide()


func options_show(options):
	print_debug(options)
	$Options/ButtonOption1.text = options[0].label
	$Options/ButtonOption2.text = options[1].label
	$Options.show()


func talk_complete_line():
	$Dialogue/LabelDialogue.text = talk_line
	talk_line_cursor = talk_line.length()
	emit_signal("hud_line_complete")


func talk_next_letter():
	return


func _on_Option1_pressed():
	emit_signal("option_1_pressed")
	talk_hide()
	options_hide()


func _on_Option2_pressed():
	emit_signal("option_2_pressed")
	options_hide()


func update_hp(hp, max_hp):
	if hp != max_hp:
		$PlayerFrames.visible = true
	$PlayerFrames/BarHealth.max_value = max_hp
	$PlayerFrames/BarHealth.value = hp


func death_screen():
	$TimerFadeDelay.start()


func _on_TimerFadeDelay_timeout():
	fade_out()
