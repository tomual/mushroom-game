extends Node2D

export var online_map = false
var hud

func _ready():
	
	for member in get_tree().get_nodes_in_group("hud"):
		hud = member
		hud.init(online_map)
	
	if online_map:
		var scene_network = load("res://scenes/Networking.tscn")
		var network = scene_network.instance()
		network.connect("spawn_player", self, "spawn_player")
		add_child(network)
	else:
		var scene_player = load("res://scenes/Player.tscn")
		var player = scene_player.instance()
		player.peerActive = true
		player.peerid = 1
		player.set_name("Player_%d" % player.peerid)
		spawn_player(player)


func destroy():
	for member in get_tree().get_nodes_in_group("player"):
		member.remove_from_group('player') 
	queue_free()

func spawn_player(player):
	$YSort.add_child(player)
	var previous_map_name = Global.get_previous_map()
	for member in get_tree().get_nodes_in_group("teleporter"):
		if member.from == previous_map_name:
			player.position = member.position
