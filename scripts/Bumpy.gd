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

var lines_other = [
	{"line": "Perish."}
]

var options_test = [
	{"label": "Stats", "callback": "callback_first_option"},
	{"label": "Talk", "lines": lines_other},
]

var lines = [
	{"line": "Hey dipshit.", "callback": "callback_test", "param": [5]},
	{"line": "I'll beat the shit out of you with a mackerel.", "options": options_test},
]

var lines_0 = [
	{"line": "Hey, who the hell are you."},
	{"line": "And what is that, a fucking door knob?"},
	{"line": "... Not much I can do for you. Maybe you can try swinging that thing around in the forest ahead if you felt like dying."},
]

var lines_1 = [
	{"line": "Hey, you made it out of there."},
	{"line": "You weren't as much of a worthless piece of trash than I thought."},
	{"line": "If you had some spores I can make your existence a little less miserable."},
]

var lines_no_weapon = [
	{"line": "Holy shit, a talking mushroom."},
	{"line": "- and I guess that's all there is to you. You're going to need something to defend yourself with if you want to last long here."},]

func _ready():
	type = TALK
	label_offset_x = 60
	label_offset_y = 70
	self.connect("talk", self, "receive_signal")
	
	for member in get_tree().get_nodes_in_group("hud"):
		member.connect("hud_line_complete", self, "hud_line_complete")
		member.connect("option_1_pressed", self, "option_1_pressed")
		member.connect("option_2_pressed", self, "option_2_pressed")


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


func callback_test(number):
	print_debug(number)


func activate():
	.activate()
	var data = Global.load_game()
	if !player.weapon:
		start(lines_no_weapon)
	elif data.npc_bumpy == 0:
		start(lines_0)
	elif data.npc_bumpy == 1:
		start(lines_1)
	else:
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
	Global.npc_bumpy = Global.npc_bumpy + 1
	Global.save_game()


func finish_page():
	emit_signal("talk_complete_line")


func hud_line_complete():
	print_debug("hud_line_complete")
	line_complete = true


func callback_first_option():
	HUD.open_stats()
	print_debug("callback_first_option")
	deactivate()

