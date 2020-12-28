extends Node2D

export var online_map = false
var player
var timer_miniboss
var timer_boss

func _ready():
	print_debug("Scene ready")
	HUD.init(online_map)
	
	if online_map:
		var scene_network = load("res://scenes/Networking.tscn")
		var network = scene_network.instance()
		network.connect("spawn_player", self, "spawn_player")
		add_child(network)
	else:
		var scene_player = load("res://scenes/Player.tscn")
		player = scene_player.instance()
		player.peerActive = true
		player.peerid = 1
		player.set_name("Player_%d" % player.peerid)
		spawn_player(player)
		HUD.fade_in()
	
	timer_miniboss = Timer.new()
	timer_miniboss.wait_time = 1
	timer_miniboss.one_shot = true
	timer_miniboss.connect("timeout", self, "summon_miniboss")
	add_child(timer_miniboss)
#	timer_miniboss.start()
	
	timer_boss = Timer.new()
	timer_boss.wait_time = 3
	timer_boss.one_shot = true
	timer_boss.connect("timeout", self, "summon_boss")
	add_child(timer_boss)
#	timer_boss.start()


func destroy():
	for member in get_tree().get_nodes_in_group("player"):
		member.remove_from_group('player') 
	queue_free()


func spawn_player(player):
	Global.save_game()
	self.player = player
	$YSort.add_child(player)
	var previous_map_name = Global.get_previous_map()
	var position_set = false
	var last_teleport
	for member in get_tree().get_nodes_in_group("teleporter"):
		last_teleport = member
		print(member.to)
		print(previous_map_name)
		if member.to == previous_map_name:
			player.position = member.position
			position_set = true
	if !position_set:
		player.position = last_teleport.position
	


func summon_miniboss():
	print("summon_miniboss")
	var scene = load("res://scenes/Miniboss.tscn")
	var miniboss = scene.instance()
	miniboss.player = player
	miniboss.position = Vector2(100, 100)
	$YSort.add_child(miniboss)
	
func summon_boss():
	print("summon_boss")
	var scene = load("res://scenes/Boss.tscn")
	var boss = scene.instance()
	boss.player = player
	boss.position = Vector2(462, 95)
	$YSort.add_child(boss)
