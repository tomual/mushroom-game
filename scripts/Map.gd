extends Node2D

var main

func _ready():
	var scene = load("res://scenes/Player.tscn")
	var player = scene.instance()
	$YSort.add_child(player)
		
	for member in get_tree().get_nodes_in_group("main"):
		member.init()
		main = member
	
	for member in get_tree().get_nodes_in_group("hud"):
		member.init()
		
	var previous_map = main.get_previous_map()
	for member in get_tree().get_nodes_in_group("teleporter"):
		if member.from == previous_map:
			player.position = member.position


func destroy():
	for member in get_tree().get_nodes_in_group("player"):
		member.remove_from_group('player') 
	queue_free()
