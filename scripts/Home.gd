extends "Map.gd"


func _ready():
	if !player.weapon:
		for member in get_tree().get_nodes_in_group("teleporterhouse"):
			member.get_node("CollisionShape2D").disabled = true
		for member in get_tree().get_nodes_in_group("knobdoor"):
			member.get_node("CollisionShape2D").disabled = false
	for member in get_tree().get_nodes_in_group("interactable"):
		member.connect("show_house_teleport", self, "show_house_teleport")


func show_house_teleport():
	for member in get_tree().get_nodes_in_group("teleporterhouse"):
		member.get_node("CollisionShape2D").disabled = false
	for member in get_tree().get_nodes_in_group("knobdoor"):
		member.get_node("CollisionShape2D").disabled = true
