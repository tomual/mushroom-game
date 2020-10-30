extends Area2D

export var id = 0
export var item_id = 0
export var phase = 0
export var watered = 0


func _on_Mound_area_entered(area):
	if area.name == "JouroWater":
		print_debug("Watered!")
		$TimerJouro.start()


func _on_Mound_area_exited(area):
	$TimerJouro.stop()


func _on_Timer_timeout():
	$AnimatedSprite.frame = 1
	watered = 1


func plant(item_id):
	self.item_id = item_id
	phase = 1
	$PhaseSprite.frame = phase
	print_debug(item_id)
