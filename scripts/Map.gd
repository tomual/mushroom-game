extends Node2D

func _ready():
	var scene = load("res://scenes/Player.tscn")
#	var player = scene.instance()
#	$YSort.add_child(player)
	
	for member in get_tree().get_nodes_in_group("hud"):
		member.init()
		
#	var previous_map = Global.get_previous_map()
#	for member in get_tree().get_nodes_in_group("teleporter"):
#		if member.from == previous_map:
#			player.position = member.position
	
	scene = load("res://scenes/Networking.tscn")
	var network = scene.instance()
	network.connect("spawn_player", self, "spawn_player")
	add_child(network)


func destroy():
	for member in get_tree().get_nodes_in_group("player"):
		member.remove_from_group('player') 
	queue_free()

func spawn_player(node):
	$YSort.add_child(node)
