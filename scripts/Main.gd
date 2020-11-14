extends Node2D

signal grow(id, phase)

var hud
var player
var previous_map

enum {
	HEALTH_HEAL,
	STAMINA_HEAL,
	HEALTH_REGEN,
	STAMINA_REGEN,
	SPEED,
	ATTACK_SPEED,
	ATTACK_POWER,
}

var dictionary_item = {
	0: {"name": "leaves", "description": "hello", "use": {"type": "buff", "buff": HEALTH_HEAL, "duration": 10, "effect": 2}},
	1: {"name": "urn", "description": "hello"},
	2: {"name": "mushroom", "description": "hello"},
	3: {"name": "rotten berry", "description": "hello"},
	4: {"name": "garl teeth", "description": "hello"},
	5: {"name": "peppy seeds", "description": "may you never know", "use": {"type": "plant"}},
	6: {"name": "merry seeds", "description": "hello"},
	7: {"name": "crystal heart", "description": "hello"},
}

var dictionary_buffs = {
	HEALTH_HEAL: "buff_health_heal",
	STAMINA_HEAL: "buff_stamina_heal",
	HEALTH_REGEN: "buff_health_regen",
	STAMINA_REGEN: "buff_health_regen",
	SPEED: "buff_speed",
	ATTACK_SPEED: "buff_attack_speed",
	ATTACK_POWER: "buff_attack_power",
}

var mounds  = {
	1: {"item_id": 1, "phase":1, "timer": 0},
	2: {"item_id": 1, "phase":2, "timer": 2},
	3: {"item_id": -1, "phase":0, "timer": 0},
	4: {"item_id": -1, "phase":0, "timer": 0},
}

func _ready():
	print_debug("test")
	for i in range(1, 5):
		var timer = get_node("TimerMound" + str(i))
		timer.connect("timeout", self, "timeout_mound", [i])
		timer.wait_time = 3 - mounds[i].timer
		timer.start()

func init():
	init_listeners()


func init_listeners():
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("move", self, "move")


func set_player(node):
	player = node


func set_hud(node):
	hud = node


func set_previous_map(name):
	previous_map = name


func get_previous_map():
	return previous_map


func move(to):
	for member in get_tree().get_nodes_in_group("map"):
		previous_map = member.name
		member.destroy()
	var scene = load("res://scenes/maps/" + to + ".tscn")
	var map = scene.instance()
	get_tree().root.get_node("Main").add_child(map)


func set_mound_data(id, item_id, phase):
	mounds[id].item_id = item_id
	mounds[id].phase = phase


func get_mound_data(id):
	return mounds[id]

func timeout_mound(id):
	if mounds[id].phase < 4:
		mounds[id].phase = mounds[id].phase + 1
		emit_signal("grow", id)
		var timer = get_node("TimerMound" + str(id))
		timer.wait_time = 5
		timer.start()
		
