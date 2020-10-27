extends CanvasLayer

signal hud_line_complete()
signal option_1_pressed()
signal option_2_pressed()

var cooldown
var talking = false
var talk_line_cursor = 0
var talk_line = ""
var player
var main


var inventory_slots
var selected_slot = -1

func _ready():
	init()
	for member in get_tree().get_nodes_in_group("main"):
		member.set_hud(self)
		main = member
	cooldown = Timer.new()
	cooldown.wait_time = 0.2
	cooldown.one_shot = true
	add_child(cooldown)
	
	# Inventory
	$Inventory.visible = false
	$Inventory/Control/Slots/Slot0.connect("focus_entered", self, "on_Slot_focus_entered", [0])
	$Inventory/Control/Slots/Slot1.connect("focus_entered", self, "on_Slot_focus_entered", [1])
	$Inventory/Control/Slots/Slot2.connect("focus_entered", self, "on_Slot_focus_entered", [2])
	$Inventory/Control/Slots/Slot3.connect("focus_entered", self, "on_Slot_focus_entered", [3])
	$Inventory/Control/Slots/Slot4.connect("focus_entered", self, "on_Slot_focus_entered", [4])
	$Inventory/Control/Slots/Slot5.connect("focus_entered", self, "on_Slot_focus_entered", [5])
	$Inventory/Control/Slots/Slot6.connect("focus_entered", self, "on_Slot_focus_entered", [6])
	$Inventory/Control/Slots/Slot7.connect("focus_entered", self, "on_Slot_focus_entered", [7])
	
	inventory_slots = [
		$Inventory/Control/Slots/Slot0,
		$Inventory/Control/Slots/Slot1,
		$Inventory/Control/Slots/Slot2,
		$Inventory/Control/Slots/Slot3,
		$Inventory/Control/Slots/Slot4,
		$Inventory/Control/Slots/Slot5,
		$Inventory/Control/Slots/Slot6,
		$Inventory/Control/Slots/Slot7,
	]


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


func init():
	fade_in()
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
	$ColorRectFade.visible = true
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.18, 0.2, 0.36, 1), Color(0.18, 0.2, 0.36, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
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


func update_inventory():
	var inventory = player.inventory
	print_debug(inventory)
	for i in range(0, 8):
		if inventory[i][0] > 0:
			inventory_slots[i].get_node("AnimatedSprite").scale = Vector2(2, 2)
			inventory_slots[i].get_node("AnimatedSprite").frame = inventory[i][0]
			inventory_slots[i].get_node("Count").text = str(inventory[i][1])
		else:
			inventory_slots[i].get_node("AnimatedSprite").scale = Vector2(0, 0)
			inventory_slots[i].get_node("Count").text = ""
	if selected_slot > -1 and inventory[selected_slot][1] <= 0:
		inventory_slots[selected_slot].get_node("AnimatedSprite").scale = Vector2(0, 0)
		inventory_slots[selected_slot].get_node("Count").text = ""
		$Inventory/Control/Detail/ButtonUse.disabled = true
		$Inventory/Control/Detail/ButtonDrop.disabled = true
		$Inventory/Control/Detail/Title.text = "Select an item"
		$Inventory/Control/Detail/Description.text = ""


func close_windows():
	$Inventory.visible = false
	

func is_window_open():
	return $Inventory.visible


func on_Slot_focus_entered(slot):
	var inventory = player.inventory
	var dictionary_item = main.dictionary_item
	selected_slot = slot
	if inventory[slot][0] != -1:
		$Inventory/Control/Detail/Title.text = dictionary_item[inventory[slot][0]].name
		$Inventory/Control/Detail/Description.text = dictionary_item[inventory[slot][0]].description
		$Inventory/Control/Detail/ButtonDrop.disabled = false
		if dictionary_item[inventory[slot][0]].use != null:
			$Inventory/Control/Detail/ButtonUse.disabled = false
	else:
		$Inventory/Control/Detail/Title.text = "Select an item"
		$Inventory/Control/Detail/Description.text = ""
		$Inventory/Control/Detail/ButtonUse.disabled = true
		$Inventory/Control/Detail/ButtonDrop.disabled = true


func _on_ButtonUse_pressed():
	player.use_item(selected_slot)


func _on_ButtonDrop_pressed():
	pass # Replace with function body.
