extends Node2D


func _ready():
	HUD.init(false)
	HUD.fade_in()


func _on_ButtonCommence_pressed():
	$TimerFadeOut.start()
	HUD.fade_out()


func _on_TimerFadeOut_timeout():
	var game = Global.load_game()
	if game and game.has('map'):
		Global.move(game.map)
	else:
		Global.move("Home")


func _on_ButtonQuit_pressed():
	get_tree().quit()


func destroy():
	queue_free()
