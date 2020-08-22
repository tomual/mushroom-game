extends CanvasLayer

func _ready():
	init()


func init():
	fade_in()
	init_label_interactive()
	init_listeners()
	dialogue_hide()


func interactable_available(position, label):
	$LabelInteractable.text = label
	$LabelInteractable.visible = true
	$LabelInteractable.set_position(position)
	$TweenInteractable.start()


func interactable_unavailable():
	$LabelInteractable.visible = false


func fade_out():
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.37, 0.37, 0.71, 0), Color(0.37, 0.37, 0.71, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func fade_in():
	$TweenFade.stop_all()
	$TweenFade.interpolate_property($ColorRectFade, "color", Color(0.37, 0.37, 0.71, 1), Color(0.37, 0.37, 0.71, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenFade.start()


func init_listeners():
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("interactable_available", self, "interactable_available")
		member.connect("interactable_unavailable", self, "interactable_unavailable")
		member.connect("fade_out", self, "fade_out")
		member.connect("dialogue_show", self, "dialogue_show")
		member.connect("dialogue_hide", self, "dialogue_hide")
		member.connect("dialogue_complete_line", self, "dialogue_complete_line")


func init_label_interactive():
	$LabelInteractable.visible = false
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1,1), Vector2(1.1, 1.1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_scale", Vector2(1.1,1.1), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 0, 5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$TweenInteractable.interpolate_property($LabelInteractable, "rect_rotation", 5, -5, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)


func dialogue_show(line):
	$Dialogue.show()
	$Dialogue/LabelDialogue.text = line


func dialogue_hide():
	$Dialogue.hide()


func dialogue_complete_line():
	$Dialogue.hide()
