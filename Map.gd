extends Node2D


func _ready():
	print_debug("map ready")
	var scene = load("res://Player.tscn")
	var player = scene.instance()
	$YSort.add_child(player)
	
	for member in get_tree().get_nodes_in_group("hud"):
		print_debug(member)
		member.init()
