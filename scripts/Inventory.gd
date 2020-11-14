extends NinePatchRect

var main
var player
var slots
var selected_slot = -1

func _ready():
	$Control/Slots/Slot0.connect("focus_entered", self, "on_Slot_focus_entered", [0])
	$Control/Slots/Slot1.connect("focus_entered", self, "on_Slot_focus_entered", [1])
	$Control/Slots/Slot2.connect("focus_entered", self, "on_Slot_focus_entered", [2])
	$Control/Slots/Slot3.connect("focus_entered", self, "on_Slot_focus_entered", [3])
	$Control/Slots/Slot4.connect("focus_entered", self, "on_Slot_focus_entered", [4])
	$Control/Slots/Slot5.connect("focus_entered", self, "on_Slot_focus_entered", [5])
	$Control/Slots/Slot6.connect("focus_entered", self, "on_Slot_focus_entered", [6])
	$Control/Slots/Slot7.connect("focus_entered", self, "on_Slot_focus_entered", [7])
	
	slots = [
		$Control/Slots/Slot0,
		$Control/Slots/Slot1,
		$Control/Slots/Slot2,
		$Control/Slots/Slot3,
		$Control/Slots/Slot4,
		$Control/Slots/Slot5,
		$Control/Slots/Slot6,
		$Control/Slots/Slot7,
	]


func update():
	var inventory = player.inventory
	print_debug(inventory)
	for i in range(0, 8):
		if inventory[i][0] > 0:
			slots[i].get_node("AnimatedSprite").scale = Vector2(2, 2)
			slots[i].get_node("AnimatedSprite").frame = inventory[i][0]
			slots[i].get_node("Count").text = str(inventory[i][1])
		else:
			slots[i].get_node("AnimatedSprite").scale = Vector2(0, 0)
			slots[i].get_node("Count").text = ""
	if selected_slot > -1 and inventory[selected_slot][1] <= 0:
		slots[selected_slot].get_node("AnimatedSprite").scale = Vector2(0, 0)
		slots[selected_slot].get_node("Count").text = ""
		$Control/Detail/ButtonUse.disabled = true
		$Control/Detail/ButtonDrop.disabled = true
		$Control/Detail/Title.text = "Select an item"
		$Control/Detail/Description.text = ""


func on_Slot_focus_entered(slot):
	var inventory = player.inventory
	var dictionary_item = main.dictionary_item
	selected_slot = slot
	if inventory[slot][0] != -1:
		$Control/Detail/Title.text = dictionary_item[inventory[slot][0]].name
		$Control/Detail/Description.text = dictionary_item[inventory[slot][0]].description
		$Control/Detail/ButtonDrop.disabled = false
		if dictionary_item[inventory[slot][0]].has('use'):
			$Control/Detail/ButtonUse.disabled = false
	else:
		$Control/Detail/Title.text = "Select an item"
		$Control/Detail/Description.text = ""
		$Control/Detail/ButtonUse.disabled = true
		$Control/Detail/ButtonDrop.disabled = true


func _on_ButtonUse_pressed():
	player.use_item(selected_slot)


func _on_ButtonDrop_pressed():
	print_debug("drop!")
