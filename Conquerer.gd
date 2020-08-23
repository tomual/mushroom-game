extends "Interactable.gd"

signal talk_show(line)
signal talk_hide()
signal talk_complete_line()

var talking = false
var lines_index = 0
var line_complete = false
var lines = [
	{"line": "Line 1"},
	{"line": "Line 2", "callback": "callback_choose", "param": "5"},
	{"line": "Line 3", "options": options1},
]


var options1 = [
	{"label": "First option", "callback": "callback_first_option"},
	{"label": "Second option", "lines": lines2},
]


var lines2 = [
	{"line": "So you picked the second option."},
	{"line": "Good job."},
]


func _ready():
	type = TALK
	label_offset_x = 24
	label_offset_y = 120
	self.connect("talk", self, "receive_signal")
	
	for member in get_tree().get_nodes_in_group("hud"):
		member.connect("hud_line_complete", self, "hud_line_complete")


func _process(delta):
	if talking and $TimerTalkCooldown.is_stopped():
		if Input.is_action_pressed("ui_accept"):
			if line_complete:
				$TimerTalkCooldown.start()
				next_page()
			else:
				$TimerTalkCooldown.start()
				finish_page()


func receive_signal(target_id):
	print_debug("receive_signal")
	if id == target_id:
		start()


func callback_test(number):
	print_debug(number)


func start():
	print_debug("start")
	talking = true
	lines_index = 0
	$TimerTalkCooldown.start()
	next_page()


func next_page():
	print_debug("next_page")
	line_complete = false
	if lines_index >= lines.size():
		end()
		return
	print_debug(lines[lines_index])
	emit_signal("talk_show", lines[lines_index].line)
	lines_index += 1


func end():
	talking = false
	emit_signal("talk_hide")
	deactivate()


func finish_page():
	emit_signal("talk_complete_line")


func hud_line_complete():
	print_debug("hud_line_complete")
	line_complete = true
