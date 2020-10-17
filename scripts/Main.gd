extends Node2D

var hud
var player
var previous_map


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
