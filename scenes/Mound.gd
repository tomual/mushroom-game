extends Area2D

func _on_Mound_area_entered(area):
	if area.name == "JouroWater":
		print_debug("Watered!")
		$Timer.start()


func _on_Mound_area_exited(area):
	$Timer.stop()


func _on_Timer_timeout():
	$AnimatedSprite.frame = 1
