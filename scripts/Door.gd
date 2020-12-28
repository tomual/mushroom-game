extends "../scripts/Interactable.gd"

signal talk_show(line)
signal talk_hide()
signal talk_complete_line()
signal options_show(options)
signal options_hide()

var talking = false
var lines_index = 0
var line_complete = false
var waiting_option = false
var current_options
var current_lines

var lines = [
	{"line": "There's a door. You go to turn the door handle."},
	{"line": "The doorknob snaps right off. You're holding it now. You'll probably hold it for a while.", "callback": "callback_give_knob"},
]


func _ready():
	type = LOOK
	label_offset_x = 60
	label_offset_y = 70
	self.connect("talk", self, "receive_signal")
	
	for member in get_tree().get_nodes_in_group("hud"):
		member.connect("hud_line_complete", self, "hud_line_complete")


func _process(delta):
	if talking and $TimerTalkCooldown.is_stopped() and !waiting_option:
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
		start(lines)


func callback_give_knob():
	print_debug("callback_give_knob")
	player.set_weapon()


func activate():
	.activate()
	start(lines)


func start(lines):
	HUD.talk_target = self
	current_lines = lines
	print_debug("start")
	talking = true
	lines_index = 0
	$TimerTalkCooldown.start()
	next_page()


func next_page():
	print_debug("next_page")
	line_complete = false
	if lines_index >= current_lines.size():
		end()
		deactivate()
		return
	print_debug(current_lines[lines_index])
	HUD.talk_show(current_lines[lines_index].line)
	
	if current_lines[lines_index].has("options"):
		print_debug(current_lines[lines_index].options)
		HUD.options_show(current_lines[lines_index].options)
		waiting_option = true
		current_options = current_lines[lines_index].options

	if current_lines[lines_index].has("callback"):
		print_debug(current_lines[lines_index].callback)
		if current_lines[lines_index].has("param"):
			callv(current_lines[lines_index].callback, current_lines[lines_index].param)
		else:
			call(current_lines[lines_index].callback)

	lines_index += 1


func option_1_pressed():
	if !talking:
		return
	end()
	if current_options[0].has("callback"):
		call(current_options[0].callback)
	if current_options[0].has("lines"):
		start(current_options[0].lines)


func option_2_pressed():
	if !talking:
		return
	end()
	if current_options[1].has("callback"):
		call(current_options[1].callback)
	if current_options[1].has("lines"):
		start(current_options[1].lines)


func end():
	talking = false
	waiting_option = false
	HUD.talk_hide()


func finish_page():
	emit_signal("talk_complete_line")


func hud_line_complete():
	print_debug("hud_line_complete")
	line_complete = true


func callback_first_option():
	HUD.open_stats()
	print_debug("callback_first_option")
	deactivate()

