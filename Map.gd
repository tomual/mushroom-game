extends Node2D


func _ready():
	var scene = load("res://Player.tscn")
	var player = scene.instance()
	$YSort.add_child(player)
	
	for member in get_tree().get_nodes_in_group("hud"):
		member.init()

func delete():
	for member in get_tree().get_nodes_in_group("player"):
		member.remove_from_group('player') 
	queue_free()
