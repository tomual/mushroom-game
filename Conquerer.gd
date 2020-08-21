extends "Interactable.gd"

var talking = false
var lines_index = 0
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


func _process(delta):
	if talking and $TimerTalkCooldown.is_stopped():
		if Input.is_action_pressed("ui_accept"):
			$TimerTalkCooldown.start()
			next_page()


func receive_signal(target_id):
	print_debug("receive_signal")
	if id == target_id:
		start()


func callback_test(number):
	print_debug(number)


func start():
	talking = true
	lines_index = 0


func next_page():
	if lines_index >= lines.size():
		end()
		return
	print_debug(lines[lines_index])
	lines_index += 1


func end():
	talking = false
	deactivate()
