extends CanvasLayer

signal hud_line_complete()

var talking = false
var talk_line_cursor = 0
var talk_line = ""

func _ready():
	init()


func _process(delta):
	if talking and talk_line.length() >= talk_line_cursor + 1:
		$Dialogue/LabelDialogue.text = $Dialogue/LabelDialogue.text + talk_line[talk_line_cursor]
		talk_line_cursor = talk_line_cursor + 1
		if talk_line.length() <= talk_line_cursor + 1:
			talk_complete_line()


func init():
	fade_in()
	init_label_interactive()
	init_listeners()
	talk_hide()


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
		member.connect("talk_show", self, "talk_show")
		member.connect("talk_hide", self, "talk_hide")
		member.connect("talk_complete_line", self, "talk_complete_line")


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


func talk_complete_line():
	$Dialogue/LabelDialogue.text = talk_line
	emit_signal("hud_line_complete")


func talk_next_letter():
	return
