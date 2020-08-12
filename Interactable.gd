extends Area2D

signal interactable_available(position)


func _on_Interactable_area_entered(area):
	emit_signal("interactable_available", get_parent().position)
