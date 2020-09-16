extends CanvasLayer


func _on_ButtonPlay_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_ButtonQuit_pressed():
	get_tree().quit()

