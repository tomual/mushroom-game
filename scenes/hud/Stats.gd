extends NinePatchRect

var player
var cost


func open():
	update()
	visible = true


func update():
	print("update")


func confirm():
	print("confirm")


func _on_ButtonCancelStats_pressed():
	visible = false


func _on_ButtonConfirm_pressed():
	confirm()


func change_stat(amount, stat):
	pass # Replace with function body.
