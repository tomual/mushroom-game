extends NinePatchRect


export var selected_dungeon_id = 1



func _on_CheckBox_toggled(button_pressed, dungeon_id):
	print_debug(button_pressed)
	print_debug(dungeon_id)
	if button_pressed:
		selected_dungeon_id = dungeon_id


func enter_dungeon():
	$TimerFadeOut.start()
	HUD.fade_out()


func open():
	visible = true
	

func _on_ButtonEnter_pressed():
	enter_dungeon()


func _on_ButtonCancelEnter_pressed():
	visible = false


func _on_TimerFadeOut_timeout():
		Global.move("Dungeon" + str(selected_dungeon_id))
