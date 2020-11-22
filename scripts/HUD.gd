extends CanvasLayer

signal hud_line_complete()
signal option_1_pressed()
signal option_2_pressed()

var cooldown
var talking = false
var talk_line_cursor = 0
var talk_line = ""
var player

func _ready():
	init(false)
	cooldown = Timer.new()
	cooldown.wait_time = 0.2
	cooldown.one_shot = true
	add_child(cooldown)
	close_windows()
	
	$ColorRectFade.visible = true
	$ColorRectFade.color = Color(0.18, 0.2, 0.36, 1)


func _process(delta):
	if talking and talk_line.length() >= talk_line_cursor + 1:
		$Dialogue/LabelDialogue.text = $Dialogue/LabelDialogue.text + talk_line[talk_line_cursor]
		talk_line_cursor = talk_line_cursor + 1
		if talk_line.length() <= talk_line_cursor + 1:
			talk_complete_line()
	if Input.is_action_pressed("inventory") and cooldown.is_stopped():
		$Inventory.visible = !$Inventory.visible
		cooldown.start()
	if Input.is_action_pressed("ui_cancel"):
		close_windows()


func init(online_map):
	if online_map:
		$LabelConnecting.visible = true
	init_label_interactive()
	init_listeners()
	talk_hide()
	options_hide()


func set_player(node):
	player = node
	player.connect("update_health", self, "update_hp")
	player.connect("update_stamina", self, "update_stamina")
	player.connect("update_spores", self, "update_spores")
	player.connect("die", self, "death_screen")
	$Inventory.player = player
	$Inventory.update()
	$Upgrade.player = player
	$Upgrade.update()
	$Zap.player = player
	$Zap.update()


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
	$ColorRectFade.visible = true
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.18, 0.2, 0.36, 0), Color(0.18, 0.2, 0.36, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func fade_in():
	$LabelConnecting.visible = false
	$ColorRectFade.visible = true
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.18, 0.2, 0.36, 1), Color(0.18, 0.2, 0.36, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func init_listeners():
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("interactable_available", self, "interactable_available")
		member.connect("interactable_unavailable", self, "interactable_unavailable")
#		member.connect("fade_out", self, "fade_out")
#		member.connect("talk_show", self, "talk_show")
#		member.connect("talk_hide", self, "talk_hide")
#		member.connect("talk_complete_line", self, "talk_complete_line")
#		member.connect("options_show", self, "options_show")
#		member.connect("options_hide", self, "options_hide")


func set_listen_interactable(node):
	node.connect("interactable_available", self, "interactable_available")
	node.connect("interactable_unavailable", self, "interactable_unavailable")


func init_label_interactive():
	$LabelInteractable.visible = false
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1.1,1.1), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 0, 5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 5, -5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)


func talk_show(line):
	print_debug("talk_show")
	$Dialogue/LabelDialogue.text = ""
	$Dialogue.show()
	talking = true
	talk_line_cursor = 0
	talk_line = line


func talk_hide():
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


func update_inventory():
	$Inventory.update()


func update_hp(hp, max_hp):
	$PlayerFrames/PlayerFramesInner/BarHealth.max_value = max_hp
	$PlayerFrames/PlayerFramesInner/BarHealth.value = hp


func update_stamina(stamina, max_stamina):
	$PlayerFrames/PlayerFramesInner/BarStamina.max_value = max_stamina
	$PlayerFrames/PlayerFramesInner/BarStamina.value = stamina


func update_spores(spores):
	$PlayerFrames/PlayerFramesInner/LabelSpores.text = "* " + str(spores)


func death_screen():
	$TimerDeath.start()


func _on_TimerDeath_timeout():
	fade_out()


func _on_TweenFade_tween_completed(object, key):
	if $ColorRectFade.color.a == 0:
		$ColorRectFade.visible = false


func close_windows():
	$Inventory.visible = false
	$Upgrade.visible = false
	$Zap.visible = false


func is_window_open():
	return $Inventory.visible or $Upgrade.visible or $Zap.visible


func open_upgrade():
	$Upgrade.open()


func open_zap():
	$Zap.open()

